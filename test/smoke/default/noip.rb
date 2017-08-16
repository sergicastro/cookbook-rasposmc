describe service('noip') do
  it { should be_running }
end

describe package('expect') do
  it { should_not be_installed }
end
