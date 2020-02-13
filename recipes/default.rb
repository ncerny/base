#
# Cookbook:: base
# Recipe:: default
#
# Copyright:: 2019, Nathan Cerny, All Rights Reserved.

execute 'install-dnf-plugin-versionlock' do
  command "dnf install 'dnf-command(versionlock)'"
  not_if 'dnf versionlock'
end

include_recipe "#{cookbook_name}::swapoff"
include_recipe "#{cookbook_name}::tunables"
include_recipe "#{cookbook_name}::crio"
include_recipe "#{cookbook_name}::kubernetes"
