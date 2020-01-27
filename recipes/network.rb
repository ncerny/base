#
# Cookbook:: base
# Recipe:: network
#
# Copyright:: 2019, Nathan Cerny, All Rights Reserved.

file '/etc/netplan/01-netcfg.yaml' do
  action :delete
end

template '/etc/netplan/01-chef.yaml' do
  source 'netplan.yaml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  notifies :run, 'execute[netplan generate]', :immediately
  notifies :run, 'execute[netplan apply]', :immediately
end

execute 'netplan generate' do
  action :nothing
end

execute 'netplan apply' do
  action :nothing
end
