class DataSupport

  DATA_PATH = File.expand_path('../../data/', __FILE__)

  class << self

    def platform_command(platform, command)
      var_name = "@#{platform}_#{command}"
      data = instance_variable_get var_name
      return data if data
      data = File.read(File.join DATA_PATH, platform.to_s, command.to_s)
      instance_variable_set var_name, data
      data
    end
  end
end
