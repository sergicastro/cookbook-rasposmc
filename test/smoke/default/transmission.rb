# frozen_string_literal: true

describe package('transmission-daemon') do
  it { should be_installed }
end

describe service('transmission-daemon') do
  it { should be_enabled }
  it { should be_running }
end

describe file('/etc/transmission-daemon/settings.json') do
  it { should exist }
  its('content') { should match %r{.*"download-dir": "\/tmp\/testdown".*} }
  its('content') { should match %r{.*"incomplete-dir": "\/tmp\/testinc".*} }
end

describe port(9091) do
  it { should be_listening }
end
