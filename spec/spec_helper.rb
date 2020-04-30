$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mac_addresses'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  # Configure examples file
  # Uncomment if using --next-failure (or equivalent) rspec option
  # config.example_status_persistence_file_path = 'examples.txt'

  config.before(:suite) do
  end

  config.after(:suite) do
  end

  config.before(:each) do
  end

  config.after(:each) do
  end

  config.order = :random
end


## Some extension
RSpec::Matchers.define :have_attr_accessor do |field|
  match do |object_instance|
    object_instance.respond_to?(field) &&
        object_instance.respond_to?("#{field}=")
  end

  failure_message do |object_instance|
    "expected attr_accessor for '#{field}' on #{object_instance}"
  end

  failure_message_when_negated do |object_instance|
    "expected attr_accessor for '#{field}' not to be defined on #{object_instance}"
  end

  description do
    'checks to see if there is an attr accessor on the supplied object'
  end
end

RSpec::Matchers.define :have_attr_reader do |field|
  match do |object_instance|
    object_instance.respond_to?(field)
  end

  failure_message do |object_instance|
    "expected attr_reader for '#{field}' on #{object_instance}"
  end

  failure_message_when_negated do |object_instance|
    "expected attr_reader for '#{field}' not to be defined on #{object_instance}"
  end

  description do
    'checks to see if there is an attr reader on the supplied object'
  end
end

