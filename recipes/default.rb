#
# Cookbook:: base
# Recipe:: default
#
# Copyright:: 2019, Nathan Cerny, All Rights Reserved.

include_recipe "#{cookbook_name}::sshd"
include_recipe "#{cookbook_name}::network"
include_recipe "#{cookbook_name}::kubernetes"
