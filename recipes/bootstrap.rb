#
# Cookbook:: base
# Recipe:: bootstrap
#
# Copyright:: 2019, Nathan Cerny, All Rights Reserved.

hab_sup 'default' do
  bldr_url node['bldr_url']
  license 'accept'
end

hab_service "#{node['pkg_origin']}/#{node['pkg_name']}" do
  bldr_url node['bldr_url']
  channel node['pkg_channel']
  strategy 'at-once'
  topology 'standalone'
end
