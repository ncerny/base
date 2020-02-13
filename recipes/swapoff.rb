#
# Cookbook:: base
# Recipe:: swapoff
#
# Copyright:: 2019, Nathan Cerny, All Rights Reserved.

mount 'none' do
  device '/dev/mapper/fedora-swap'
  action :disable
  notifies :run, 'execute[swapoff -a]', :immediately
end

execute 'swapoff -a' do
  action :nothing
end
