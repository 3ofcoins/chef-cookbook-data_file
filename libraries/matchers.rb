if defined?(ChefSpec)
  ChefSpec.define_matcher :json_file
  ChefSpec.define_matcher :yaml_file
end
