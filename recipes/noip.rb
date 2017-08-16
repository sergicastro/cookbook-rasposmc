# Prerequisites

unless node['noip'] && node['noip']['username'] && node['noip']['password']
  Chef::Application.fatal! "The noip username and password are required for noip recipe.
  Supply the attributes: node['noip']['username'] and node['noip']['password']"
end

# Define packages

package 'expect' do
  action :nothing
end

service 'noip' do
  action :nothing
end

# Download noip
remote_file '/tmp/noip-duc-linux.tar.gz' do
  source 'https://www.noip.com/client/linux/noip-duc-linux.tar.gz'
end

bash 'extract noip' do
  cwd '/tmp'
  code <<-EOH
    tar -xf noip-duc-linux.tar.gz
  EOH
end

# Install noip

template '/tmp/noip-2.1.9-1/make-noip' do
  source 'noip/make-noip.erb'
  variables ({
      username: node['noip']['username'],
      password: node['noip']['password']
  })
  mode 0774
end

bash 'compile noip' do
  cwd '/tmp/noip-2.1.9-1'
  code <<-EOH
    ./make-noip | tee make-noip.out
  EOH
  notifies :install, 'package[expect]', :before
  notifies :purge, 'package[expect]', :immediately
end

# Configure as a service

remote_file '/etc/init.d/noip' do
  source 'file:///tmp/noip-2.1.9-1/debian.noip2.sh'
  group 'root'
  user 'root'
  mode 0755
end

bash 'register noip service' do
  code <<-EOH
    update-rc.d noip defaults
  EOH
  notifies :start, 'service[noip]', :delayed
end
