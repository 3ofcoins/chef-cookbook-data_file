Data File Cookbook
==================

[![Build Status](https://travis-ci.org/3ofcoins/chef-cookbook-data_file.svg?branch=master)](https://travis-ci.org/3ofcoins/chef-cookbook-data_file)
[![Chef Supermarket](https://img.shields.io/cookbook/v/data_file.svg)](https://supermarket.chef.io/cookbooks/data_file)
[![GitHub Issues](https://img.shields.io/github/issues/3ofcoins/chef-cookbook-data_file.svg)](https://github.com/3ofcoins/chef-cookbook-data_file/issues)

This is a library [Chef](https://www.chef.io/) cookbook that provides
resources to create data files in JSON and YAML format.

The native `file` resource has the drawback of treating files like
text: cookbook code has to take care of serializing data, and unless
you take great care to preserve data order, it often thinks that file
has changed even though the data inside it is the same (e.g. because
dictionary keys are ordered differently). This clutters `chef-client`
output and can lead to unnecessary service restarts.

The `json_file` and `yaml_file` resources exported by this cookbook
accept `data` rather than `content`, and consider changes in parsed
data rather than serialize text.

Recipes
-------

 - `data_file::default` – empty. Can be included in the role run list
   to make the resources available to other cookbooks.
 - `data_file::safe_yaml` – install
   [safe_yaml](https://rubygems.org/gems/safe_yaml) gem into Chef and
   `require`s it. It is *strongly recommended* to use this is you use
   YAML serialization/deserialization. Otherwise, it might be possible
   to prepare a malicious YAML file that would make `chef-client`
   execute arbitrary code.

Attributes
----------

None.

Resources
---------

Two resources are exported: `json_file` and `yaml_file`. They behave
identically, only difference being the serialization format. 

### Actions

Inherited from `file`:
 - `:create` (default)
 - `:create_if_missing`
 - `:delete`

### Properties

The resources have all the properties of `file` resource, except
`contents`. Two new properties are defined:

 - `data` – data to be serialized (anything with `#to_json` method,
   including node attributes)
 - `pretty` (boolean, default `false`) – if set to `true`, JSON file
   will be pretty-printed. Meaningless for `yaml_file`

The `content` method on the resource can be used to access the
serialized JSON/YAML string if anybody needs that.

### Examples

```ruby
include_recipe 'data_file::safe_yaml'
yaml_file '/etc/filebeat/prospectors.d/supervisord.yml' do
  data filebeat: {
         prospectors: [{
           paths: ['/var/log/supervisor/*.log'],
           document_type: 'supervisord'
         }]
       }
  owner 'root'
  group 'filebeat'
  mode '0640'
end
```

```ruby
json_file '/path/to/config.json' do
  data node['software']['config']
  pretty true
end
```

Testing and Development
-----------------------

Rubocop, Foodcritic, Test-kitchen with `kitchen-docker` driver. See
`test/harness.sh` & `.kitchen.yml`.

Contributing
------------

Just send a PR on [GitHub](https://github.com/3ofcoins/chef-cookbook-data_file/).

License
-------

The MIT License (MIT)

Copyright (c) 2016 Maciej Pasternacki <maciej@3ofcoins.net>

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
