# frozen_string_literal: true

describe package('unzip') do
  it { should_not be_installed }
end

describe directory('/opt/sickrage') do
  it { should exist }
end

describe package('python2.7') do
  it { should be_installed }
end

describe service('sickrage') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/default/sickrage') do
  it { should exist }
  its('content') { should match %r{SR_DATA=\/tmp\/sickrage-data} }
end

describe port(8081) do
  it { should be_listening }
end
