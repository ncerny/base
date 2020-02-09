name 'base'
maintainer 'Nathan Cerny'
maintainer_email 'ncerny@gmail.com'
license 'All Rights Reserved'
description 'Installs/Configures base'
version ::File.read('VERSION')
chef_version '>= 15.2'

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/base/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/base'

depends 'habitat'
