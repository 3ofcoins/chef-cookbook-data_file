include_recipe 'data_file::safe_yaml'

node['data_file_test']['data'].each do |name, value|
  file "/tmp/kitchen/data/serialization-#{name}_orig.json" do
    content value.to_json
  end

  json_file "/tmp/kitchen/data/serialization-#{name}.json" do
    data value
  end

  json_file "/tmp/kitchen/data/serialization-#{name}_pretty.json" do
    data value
    pretty true
  end

  yaml_file "/tmp/kitchen/data/serialization-#{name}.yml" do
    data value
  end
end
