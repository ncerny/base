#
# Cookbook:: base
# Recipe:: crio
#
# Copyright:: 2019, Nathan Cerny, All Rights Reserved.

execute "enable dnf module cri-o:#{node['kubernetes']['version']}" do
  command "dnf module enable -y cri-o:#{node['kubernetes']['version'][/([0-9]+).([0-9]+)/]}"
  not_if "dnf module list --enabled cri-o:#{node['kubernetes']['version'][/([0-9]+).([0-9]+)/]}"
end

%w(runc cri-o conman).each do |pkg|
  package pkg do
    action :install
  end

  execute "dnf-versionlock-#{pkg}" do
    command "dnf versionlock add #{pkg}"
    not_if "dnf versionlock | grep #{pkg}"
  end
end

file '/etc/containers/registries.conf' do
  content <<-EOF
    [registries.search]
    registries = ['quay.io', 'docker.io']
    EOF
end

service 'crio' do
  action [ :enable, :start ]
end

service 'crio-shutdown' do
  action [ :enable, :start ]
end
