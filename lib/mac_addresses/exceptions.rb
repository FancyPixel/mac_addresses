module MacAddresses
  module Exceptions

    class NoneOfCommandsSuccessful < StandardError
      def initialize(commands, message = nil)
        message = message || "None of #{ commands.join(', ') } succeeded returning MAC addresses info"
        super(message)
      end
    end
  end
end
