require 'pio'

# Routing table entry
class Route
  include Pio

  attr_reader :destination
  attr_reader :netmask_length
  attr_reader :next_hop

  def initialize(options)
    @destination = IPv4Address.new(options.fetch(:destination))
    @netmask_length = options.fetch(:netmask_length)
    @next_hop = IPv4Address.new(options.fetch(:next_hop))
  end

  def netmask
    IPv4Address.new('255.255.255.255').mask(netmask_length)
  end
end

# Routing table
class Routes
  def initialize(routes = [])
    @list = routes.map do |each|
      Route.new(each)
    end
  end

  def each(&block)
    @list.each(&block)
  end
end
