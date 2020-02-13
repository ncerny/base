#
# Cookbook:: base
# Recipe:: tunables
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
