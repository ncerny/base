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

package 'software-properties-common'

apt_repository 'crio' do
  uri 'ppa:projectatomic/ppa'
end

package 'cri-o-1.15'

service 'crio' do
  action [ :start, :enable ]
end

package 'apt-transport-https'

apt_repository 'kubernetes' do
  uri 'https://apt.kubernetes.io/'
  distribution 'kubernetes-xenial'
  components ['main']
  key 'https://packages.cloud.google.com/apt/doc/apt-key.gpg'
end

%w( kubelet kubeadm kubectl ).each do |pkg|
  package pkg

  execute "apt-mark hold #{pkg}" do
    not_if "apt-mark showhold | grep #{pkg}"
  end
end

service 'kubelet' do
  action [ :start, :enable ]
end
