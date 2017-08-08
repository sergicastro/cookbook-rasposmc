package 'transmission-daemon'

service 'transmission-daemon' do
    action :enable
end

template '/etc/transmission-daemon/settings.json' do
    source 'transmission/settings.erb'
    variables ({
        rpcpassword: node['transmission']['rpc-password'],
        downloaddir: node['transmission']['download-dir'],
        incompletedir: node['transmission']['incomplete-dir']
    })
    notifies :stop, 'service[transmission-daemon]', :before
    notifies :start, 'service[transmission-daemon]', :delayed
end
