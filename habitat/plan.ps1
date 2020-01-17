$pkg_name="base"
$pkg_origin="ncerny"
$pkg_version=Get-Content -Path ..\VERSION
$pkg_maintainer="Nathan Cerny <ncerny@gmail.com>"
$pkg_license=("Apache-2.0")
$pkg_upstream_url="http://chef.io"
$pkg_build_deps=@("core/chef-dk")
$pkg_deps=@(
  "core/cacerts"
  "robbkidd/chef-infra-client"
)
$pkg_scaffolding="chef/scaffolding-chef-infra"
$scaffold_policy_name="Policyfile"
$scaffold_policyfile_path="$PLAN_CONTEXT\..\"
