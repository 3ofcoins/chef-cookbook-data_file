file '/tmp/kitchen/data/mangled-same.txt' do
  content 'this should not be here'
  action :nothing
end

json_file '/tmp/kitchen/data/same.json' do
  data foo: 'bar', baz: [1, 2, 3]
  notifies :create, 'file[/tmp/kitchen/data/mangled-same.txt]'
end

file '/tmp/kitchen/data/mangled-different.txt' do
  content 'this should definitely be here'
  action :nothing
end

json_file '/tmp/kitchen/data/different.json' do
  data foo: 'bar', baz: [1, 2, 3]
  notifies :create, 'file[/tmp/kitchen/data/mangled-different.txt]'
end
