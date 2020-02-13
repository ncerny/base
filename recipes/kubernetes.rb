#
# Cookbook:: base
# Recipe:: kubernetes
#
# Copyright:: 2019, Nathan Cerny, All Rights Reserved.

file 'kubernetes.repo' do
  path '/etc/yum.repos.d/kubernetes.repo'
  content <<-EOF
[kubernetes]
name=Yum Repository
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
fastestmirror_enabled=0
gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
repo_gpgcheck=1
EOF
  notifies :run, 'execute[refresh dnf cache for kubernetes]', :immediately
end

execute 'refresh dnf cache for kubernetes' do
  action :nothing
  command 'dnf makecache --disablerepo * --enablerepo kubernetes'
end

%w(kubelet kubeadm kubectl).each do |pkg|
  package pkg do
    version node['kubernetes']['version']
    not_if "dnf list --installed #{pkg}-#{node['kubernetes']['version']}"
  end

  execute "dnf-versionlock-#{pkg}" do
    command "dnf versionlock add #{pkg}"
    not_if "dnf versionlock | grep #{pkg}"
  end
end

file '/etc/default/kubelet' do
  content 'KUBELET_EXTRA_ARGS=--cgroup-driver=systemd'
end

service 'kubelet' do
  action [ :enable, :start ]
end
