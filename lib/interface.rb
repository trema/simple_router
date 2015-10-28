require 'pio'

require 'arp_table'
require 'routing_table'

# Router network interface
class Interface
  attr_reader :hwaddr
  attr_reader :ipaddr
  attr_reader :masklen
  attr_reader :port

  def initialize(options)
    @port = options[:port]
    @hwaddr = Pio::Mac.new(options[:hwaddr])
    @ipaddr = Pio::IPv4Address.new(options[:ipaddr])
    @masklen = options[:masklen]
  end

  def has?(mac)
    mac == hwaddr
  end
end

# List of network interfaces
class Interfaces
  def initialize(interfaces = [])
    @list = []
    interfaces.each do |each|
      @list << Interface.new(each)
    end
  end

  def find_by_port(port)
    @list.find do |each|
      each.port == port
    end
  end

  def find_by_ipaddr(ipaddr)
    @list.find do |each|
      each.ipaddr == ipaddr
    end
  end

  def find_by_prefix(ipaddr)
    @list.find do |each|
      masklen = each.masklen
      each.ipaddr.mask(masklen) == ipaddr.mask(masklen)
    end
  end

  def find_by_port_and_ipaddr(port, ipaddr)
    @list.find do |each|
      each.port == port && each.ipaddr == ipaddr
    end
  end

  def ours?(port, macda)
    return true if macda.broadcast?

    interface = find_by_port(port)
    return true if !interface.nil? && interface.has?(macda)
  end
end
