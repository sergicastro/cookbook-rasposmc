
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
