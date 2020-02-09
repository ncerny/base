#
# Cookbook:: base
# Recipe:: disable_swap
#
# Copyright:: 2019, Nathan Cerny, All Rights Reserved.

mount 'none' do
  device "/dev/mapper/#{node['hostname']}--vg-swap_1"
  action :disable
  notifies :run, 'execute[swapoff -a]', :immediately
end

execute 'swapoff -a' do
  action :nothing
end
