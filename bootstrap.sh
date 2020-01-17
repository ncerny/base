#!/bin/bash

pkg_origin='ncerny'
pkg_name='base'
channel='stable'
topology='standalone'
strategy='at-once'
bldr_url='https://bldr.habitat.sh'


if [ ! -e "/bin/hab" ]; then
  wget https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh -O - | sudo bash
fi

if grep "^hab:" /etc/passwd > /dev/null; then
  echo "Hab user exists"
else
  useradd hab && true
fi

if grep "^hab:" /etc/group > /dev/null; then
  echo "Hab group exists"
else
  groupadd hab && true
fi

echo "By running this script, you accept the Chef license agreement"
hab license accept

echo "Installing $pkg_origin/$pkg_name"
hab pkg install $pkg_origin/$pkg_name

echo "Creating configuration overrides"
mkdir -p /hab/user/${pkg_name}/config/
cat > /hab/user/${pkg_name}/config/user.toml <<EOF
[chef_license]
acceptance = "accept"

[automate]
enable = false
server_url = ""
token = ""
EOF

echo "Determing pkg_prefix for $pkg_origin/$pkg_name"
pkg_prefix=$(find /hab/pkgs/$pkg_origin/$pkg_name -maxdepth 2 -mindepth 2 | sort | tail -n 1)

echo "Found $pkg_prefix"

cd $pkg_prefix
hab pkg exec $pkg_origin/$pkg_name chef-client -z -c $pkg_prefix/config/bootstrap-config.rb --chef_license accept

hab svc load $pkg_origin/$pkg_name --channel ${channel} --topology ${topology} --strategy ${strategy} --url ${bldr_url}
