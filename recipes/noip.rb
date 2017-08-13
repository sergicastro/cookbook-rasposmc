# Define packages

package 'build-essential' do
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

## TODO: Must be manual until multiple lines stdin redirect work
# bash 'compile noip' do
#   cwd '/tmp/noip-2.1.9-1'
#   code <<-EOH
#     make install
#   EOH
#   notifies :install, 'package[build-essential]', :before
# end

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
  notifies :start, 'service[noip]', :immediately
end
