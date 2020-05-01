module MacAddresses
  module Exceptions

    class NoneOfCommandsSuccessful < StandardError
      def initialize(commands, message = nil)
        message = message || "None of #{ commands.join(', ') } succeeded returning MAC addresses info"
        super(message)
      end
    end

    class ProtocolFamilyNotFound < StandardError
      def initialize(families, msg = nil)
        message = message || "Socket protocol family not found: tried with #{families.join ', '}"
        super(message)
      end
    end
  end
end
