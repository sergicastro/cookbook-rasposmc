# frozen_string_literal: true

# Define packages and services

package 'python2.7' do
  action :nothing
end

service 'sickrage' do
  action :nothing
end

group 'sickrage'
user 'sickrage' do
  group 'sickrage'
end

# Donwload and extrac sickrage

bash 'download latest sickrage' do
  cwd '/tmp'
  code <<-EOH
    wget https://github.com/SickRage/SickRage/archive/master.zip
  EOH
end

package 'unzip'
directory '/opt/sickrage'

bash 'extract latest sickrage' do
  code <<-EOH
    unzip -oq /tmp/master.zip -d /tmp
    for f in $(ls -a /tmp/SickRage-master/);
    do
      mv /tmp/SickRage-master/$f /opt/sickrage/
    done;
    #find '/tmp/sickrage/*' -exec mv \{\} /opt/sickrage/ \;
  EOH
  notifies :purge, 'package[unzip]', :immediately
  notifies :install, 'package[python2.7]', :immediately
end

# Create sickrage daemon config

template '/etc/default/sickrage' do
  source 'sickrage/sickrage.erb'
  variables(
    srdata: node['sickrage']['data-dir']
  )
  group 'sickrage'
  owner 'sickrage'
end

# Create, register and start sickrage deamon

remote_file '/etc/init.d/sickrage' do
  source 'file:///opt/sickrage/runscripts/init.debian'
  group 'root'
  owner 'root'
  mode 0755
end

execute 'chown -R sickrage:sickrage /opt/sickrage' do
  user 'root'
  action :run
end

bash 'register sickrage service' do
  code <<-EOH
    update-rc.d sickrage defaults
  EOH
  notifies :start, 'service[sickrage]', :delayed
end
