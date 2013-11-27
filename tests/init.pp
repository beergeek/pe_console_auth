# The baseline for module testing used by Puppet Labs is that each manifest
# should have a corresponding test manifest that declares that class or defined
# type.
#
# Tests are then run by using puppet apply --noop (to check for compilation
# errors and view a log of events) or by fully applying the test in a virtual
# environment (to compare the resulting system state to the desired state).
#
# Learn more about module testing here:
# http://docs.puppetlabs.com/guides/tests_smoke.html
#
#include pe_console_auth
class {'pe_console_auth':
  database_passwd  => 'c9rVnPKFFPO9ghCZ4724',
  ldap_enable      => true,
  ldap_host        => 'master.puppetlabs.vm',
  ldap_port        => 389,
  ldap_base        => 'dc=example,dc=net',
  ldap_filter      => 'uid',
  ldap_auth_user   => 'bob',
  ldap_auth_passwd => 'password',
  ad_enable        => true,
  ad_host          => 'ad.puppetlabs.vm',
  ad_base          => 'cn=crap',
  ad_filter        => '(Object=person)',
  ad_auth_user     => 'bob',
  ad_auth_passwd   => 'vfjnbakjndfkj',
  google_enable    => true,
  order            => ['ldap','google','ad'],
  session_secret   => '2d74513d176ca5381032fcdf303b9afe10dd9a58186b6babb894d4ced03e6c7208b02dd01b7089f8c4d1d18fd9febfa285091d11a577066b78d7fc26d056c941',
}
