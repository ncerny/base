#
# Cookbook:: base
# Recipe:: kubernetes
#
# Copyright:: 2019, Nathan Cerny, All Rights Reserved.

%w(
  overlay
  br_netfilter
).each do |mod|
  kernel_module mod do
    action :install
  end
end

%w(
  net.ipv4.ip_forward
  net.bridge.bridge-nf-call-iptables
  net.bridge.bridge-nf-call-ip6tables
).each do |param|
  sysctl param do
    value 1
  end
end

%w( software-properties-common apt-transport-https ).each do |pkg|
  package pkg
end

apt_repository 'crio' do
  uri 'ppa:projectatomic/ppa'
end

%w( cri-o-1.15 conmon podman runc ).each do |pkg|
  package pkg
end

# No clue why this isn't created with the packages
directory '/usr/libexec/crio/conmon'

service 'crio' do
  action [ :enable, :start ]
end

link '/usr/bin/rm' do
  to '/bin/rm'
end

link '/usr/bin/bash' do
  to '/bin/bash'
end

service 'crio-shutdown' do
  action [ :enable, :start ]
end

apt_repository 'kubernetes' do
  uri 'https://apt.kubernetes.io/'
  distribution 'kubernetes-xenial'
  components ['main']
  key 'https://packages.cloud.google.com/apt/doc/apt-key.gpg'
end

%w( kubernetes-cni kubelet kubeadm kubectl ).each do |pkg|
  package pkg

  execute "apt-mark hold #{pkg}" do
    not_if "apt-mark showhold | grep #{pkg}"
  end
end

service 'kubelet' do
  action [ :enable, :start ]
end

template '/hab/user/consul/config/user.toml' do
  source 'consul_user.toml.erb'
end

template '/hab/user/vault/config/user.toml' do
  source 'vault_user.toml.erb'
end

template '/hab/user/traefik/config/user.toml' do
  source 'traefik_user.toml.erb'
end

hab_service 'ncerny/consul' do
  bldr_url node['bldr_url']
  channel node['pkg_channel']
  strategy 'at-once'
  topology 'standalone'
  retries 3
end

hab_service 'ncerny/vault' do
  bldr_url node['bldr_url']
  channel node['pkg_channel']
  strategy 'at-once'
  topology 'standalone'
  retries 3
end

hab_service 'ncerny/traefik' do
  bldr_url node['bldr_url']
  channel node['pkg_channel']
  strategy 'at-once'
  topology 'standalone'
  retries 3
end
