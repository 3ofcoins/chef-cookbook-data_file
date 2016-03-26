require 'minitest/autorun'

require 'json'
require 'yaml'

describe 'data_file' do
  it 'serializes JSON data' do
    Dir['/tmp/kitchen/data/serialization-*_orig.json'].each do |sample|
      data = JSON.load(File.read(sample))
      root = sample.sub(/_orig\.json$/, '')
      assert_equal data, JSON.load(File.read("#{root}.json"))
      assert_equal data, JSON.load(File.read("#{root}_pretty.json"))
      assert_equal data, YAML.load(File.read("#{root}.yml"))
    end
  end

  it 'creates a file with expected ownership & permissions' do
    path = '/tmp/kitchen/data/created.json'
    assert File.exist?(path)
    st = File.stat(path)
    assert_equal st.mode & 07777, 01666
    assert_equal st.uid, Etc.getpwnam('nobody').uid
    assert_equal st.gid, Etc.getgrnam('nogroup').gid
  end

  it 'does not overwrite on :create_if_missing' do
    assert !File.exist?('/tmp/kitchen/data/mangled-existing.txt')
  end

  it 'deletes file on :delete' do
    assert !File.exist?('/tmp/kitchen/data/delete-me.json')
  end

  it 'is idempotent wrt content' do
    assert !File.exist?('/tmp/kitchen/data/mangled-same.txt')
    assert File.exist?('/tmp/kitchen/data/mangled-different.txt')
  end
end
