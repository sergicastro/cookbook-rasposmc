# # encoding: utf-8

# Inspec test for recipe rasposmc::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

describe package('transmission-daemon') do
  it { should be_installed }
end

describe service('transmission-daemon') do
  it { should be_enabled }
  it { should be_running }
end

describe port(9091) do
  it { should be_listening }
end