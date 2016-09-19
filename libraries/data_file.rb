require 'chef/json_compat'
require 'chef/resource/file'
require 'chef/provider/file'

module DataFileCookbook
  class DataFileContent < Chef::Provider::File::Content
    def file_for_provider
      if @current_resource && @current_resource.data == @new_resource.data
        nil
      else
        super
      end
    end
  end

  class DataFileProvider < Chef::Provider::File
    provides :json_file
    provides :yaml_file

    def initialize(new_resource, run_context)
      @content_class ||= DataFileContent
      super
    end

    def load_current_resource
      @current_resource ||= @new_resource.class.new(new_resource.name)
      super
    end

    def load_resource_attributes_from_file(resource)
      super
      resource.parse_data(file_class.read(resource.path))
    end
  end

  class JSONFileResource < Chef::Resource::File
    resource_name :json_file

    property :data, Object,
             respond_to: :to_json,
             coerce: ->(obj) { parse_data(serialize_data(obj)) } # rubocop:disable Metrics/LineLength
    property :pretty, [true, false], default: false, desired_state: false

    # TODO: property :ignore_parse_error, [true, false],
    #                default: true, desired_state: false

    allowed_actions.delete(:touch)

    def parse_data(str)
      data(Chef::JSONCompat.parse(str))
    end

    def serialize_data(obj)
      if pretty
        Chef::JSONCompat.to_json_pretty(obj)
      else
        Chef::JSONCompat.to_json(obj)
      end
    end

    def content
      serialize_data(data)
    end
  end

  class YAMLFileResource < JSONFileResource
    resource_name :yaml_file

    def parse_data(str)
      unless defined?(SafeYAML)
        Chef::Log.warn("No safe_yaml loaded, please include_recipe 'data_file::safe_yaml'!") # rubocop:disable Metrics/LineLength
      end
      YAML.load(str)
    end

    def serialize_data(obj)
      YAML.dump(obj)
    end
  end
end
