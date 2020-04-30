##
# Cross platform MAC address determination.  Works for:
# * /sbin/ifconfig
# * /bin/ifconfig
# * ifconfig
# * ipconfig /all
#
# To return an array of all MAC addresses:
#
#   MacAddresses.fetch
#
# To return the fetched addresses without repeating fetch ops again:
#
#   MacAddresses.list

require 'socket'

module MacAddresses

  COMMANDS = '/sbin/ifconfig', '/bin/ifconfig', 'ifconfig', 'ipconfig /all', 'cat /sys/class/net/*/address'
  ADDRESS_REGEXP = %r/(?:[^:\-]|\A)(?:[0-9A-F][0-9A-F][:\-]){5}[0-9A-F][0-9A-F](?:[^:\-]|\Z)/io
  LINK = Socket::PF_LINK   if Socket.const_defined? :PF_LINK
  PACKET = Socket::PF_PACKET if Socket.const_defined? :PF_PACKET
  INTERFACE_PACKET_FAMILY = LINK || PACKET

  class << self

    attr_reader :addresses

    alias_method :list, :addresses

    ##
    # Discovers and returns the system's MAC addresses.
    #   MacAddresses.fetch

    def fetch
      @addresses = from_getifaddrs
      return @addresses if @addresses

      success = false
      COMMANDS.each do |cmd|
        stdout = `#{cmd}` rescue nil
        next unless stdout && stdout.length > 0
        @addresses = parse(stdout)
        success = true
        break # break as soon as we successfully parse a command output
      end

      raise "None of #{ COMMANDS.join ', ' } succeeded returning MAC addresses info" unless success

      @addresses
    end

    def from_getifaddrs
      return nil unless Socket.respond_to? :getifaddrs

      interfaces = Socket.getifaddrs.select do |addr|
        addr.addr &&  # Some VPN ifcs don't have an addr - ignore them
          addr.addr.pfamily == INTERFACE_PACKET_FAMILY
      end

      macs = if Socket.const_defined? :PF_LINK
               interfaces.map do |addr|
                 addr.addr.getnameinfo
               end.map do |m,|
                 m if (m && !m.empty?)
               end.compact
             elsif Socket.const_defined? :PF_PACKET
               interfaces.map do |addr|
                 addr.addr.inspect_sockaddr[/hwaddr=([\h:]+)/, 1]
               end.map do |mac_addr|
                 mac_addr != '00:00:00:00:00:00'
               end
             end
      macs
    end

    def parse(output)
      candidates = output.scan(ADDRESS_REGEXP).map &:strip
      raise 'No mac address candidates' unless candidates.any?
      candidates
    end
  end
end
