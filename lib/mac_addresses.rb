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
require_relative 'mac_addresses/exceptions'

module MacAddresses

  COMMANDS = '/sbin/ifconfig', '/bin/ifconfig', 'ifconfig', 'ipconfig /all', 'cat /sys/class/net/*/address'
  ADDRESS_REGEXP = /([0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2}:[0-9a-f]{2})/
  NOT_VALID_MACS = ['00:00:00:00:00:00']
  PROTOCOL_FAMILIES = 'PF_LINK', 'PF_PACKET'
  fam = PROTOCOL_FAMILIES.find { |fam| Socket.const_defined?(fam) }
  if fam
    PROTOCOL_FAMILY = Socket.const_get fam
  else
    raise Exceptions::ProtocolFamilyNotFound, PROTOCOL_FAMILIES
  end

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

      unless success
        raise Exceptions::NoneOfCommandsSuccessful, COMMANDS
      end

      @addresses
    end

    def from_getifaddrs
      return nil unless Socket.respond_to? :getifaddrs

      interfaces = Socket.getifaddrs.select do |addr|
        addr.addr &&  # Some VPN ifcs don't have an addr - ignore them
          addr.addr.pfamily == MacAddresses::PROTOCOL_FAMILY
      end

      interfaces.inject([]) do |found, iface|
        macs = parse iface.addr.inspect_sockaddr
        found << macs.select { |mac| mac != '00:00:00:00:00:00' }
      end.flatten
    end

    # Scans a string and returns an Array of found MACs
    def parse(string)
      string.scan(ADDRESS_REGEXP).flatten
    end
  end
end
