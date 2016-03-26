json_file '/tmp/kitchen/data/created.json' do
  data node['data_file_test']['data']
  owner                 'nobody'
  group                 'nogroup'
  mode                  '01666'
end

file '/tmp/kitchen/data/mangled-existing.txt' do
  content 'this should not be here'
  action :nothing
end

json_file '/tmp/kitchen/data/existing.json' do
  data modified: true
  action :create_if_missing
  notifies :create, 'file[/tmp/kitchen/data/mangled-existing.txt]'
end

json_file '/tmp/kitchen/data/delete-me.json' do
  action :delete
end
