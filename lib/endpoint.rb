require 'yaml'

class Endpoint
  attr_reader :attrs

  def initialize(route)
    @attrs = OpenStruct.new(self.class.config_file['endpoints'][route])
  end

  def to_s
    str = []
    str << "# #{attrs.verb} #{attrs.uri}"
    if attrs.params
      str << "# Params:"
      str << "# #{attrs.params.keys.join(", ")}"
    end

    str.join("<br>")
  end

  def as_curl
    commands = []
    #commands << "curl \"#{self.class.default_url}#{attrs.uri}\""
    commands << "curl \"https://triggerapp.com#{attrs.uri}\""

    headers = []
    self.class.headers.each do |header_key, header_value|
      headers << "  -H '#{header_key.capitalize}: #{header_value}'"
    end
    commands << headers.join(" \\ <br>")

    commands << "  -X #{attrs.verb}"

    if attrs.params
      str = ''
      str << "  -d '{"

      params = []
      attrs.params.each do |param_key, param_value|
        if param_value.is_a?(Hash)
          sub_str = ''
          sub_str << "{"

          param_value.each do |k, v|
            sub_str << "  \"#{k}\": \"#{v}\""
          end

          sub_str << "} "

          params << "\"#{param_key}\": #{sub_str}"
        else
          params << "  \"#{param_key}\": \"#{param_value}\""
        end
      end

      str << params.join(", ")
      str << "}'"
      commands << str
    end

    commands.join(" \\ <br />")
  end

  def self.all
    config_file['endpoints']
  end

  def self.default_url
    config_file['default_url']
  end

  def self.headers
    config_file['headers']
  end

  private

  def self.config_file
    @config_file ||= YAML.load_file("config/application.yml")
  end
end
