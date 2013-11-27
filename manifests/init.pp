# == Class: pe_console_auth
#
# Full description of class pe_console_auth here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { pe_console_auth:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2013 Your name here, unless otherwise noted.
#
class pe_console_auth(
  $ldap_enable = false,
  $ldap_default_mode = 'read-only',
  $ad_enable = false,
  $ad_default_mode = 'read-only',
  $google_enable = false,
  $google_default_mode = 'read-only',
  $database_adaptor = 'postgresql',
  $database_user = 'console_auth',
  $database_name = 'console_auth',
  $database_passwd,
  $database_host = 'localhost',
  $database_port = '5432',
  $database_user_table = 'users',
  $database_user_column = 'username',
  $database_reconnect = true,
  $google_proxy_host = undef,
  $google_proxy_port = undef,
  $google_proxy_user = 'nil',
  $google_proxy_passwd = 'nil',
  $ldap_host = undef,
  $ldap_port = '389',
  $ldap_base = undef,
  $ldap_filter =  undef,
  $ldap_encryption = undef,
  $ldap_auth_user = undef,
  $ldap_auth_passwd = undef,
  $ldap_username_attribute = 'uid',
  $ldap_extra_attributes = undef,
  $ad_host = undef,
  $ad_port = '389',
  $ad_base = undef,
  $ad_filter = undef,
  $ad_encryption = undef,
  $ad_auth_user = undef,
  $ad_auth_passwd = undef,
  $ad_extra_attributes = undef,
  $enable_single_sign_out = true,
  $maximum_unused_login_ticket_lifetime = 300,
  $maximum_unused_service_ticket_lifetime = 300,
  $maximum_session_lifetime = 1200,
  $session_secret,
  $order = ['google','ldap','ad'],
) {

  if ! is_array($order) {
    fail("The order argument must be an array")
  }

  concat {'rubycas':
    path   => '/etc/puppetlabs/rubycas-server/config.yml',
    mode   => 0600,
    owner  => 'pe-auth',
    group  => 'pe-auth',
  }   
  
  concat::fragment {'database':
    target  => 'rubycas',
    content => template('pe_console_auth/database.erb'),
    order   => 0,
  }

  if $google_enable {

    if count($order, 'google') == 0 {
      fail("With Google enabled you must have it in the order array")
    } 

    concat::fragment {'google':
      target  => 'rubycas',
      content => template('pe_console_auth/google.erb'),
      order   => find_index($order, 'google'),
    }
  }

  if $ldap_enable {

    if count($order, 'ldap') == 0 {
      fail("With LDAP enabled you must have it in the order array")
    } 

    if ! $ldap_host {
      fail("You require a LDAP host")
    }

    if ! $ldap_base {
      fail("You require a LDAP base")
    }

    if ! $ldap_filter {
      fail("You require a LDAP filter")
    }

    if ! $ldap_auth_user {
      fail("You require a LDAP user")
    }

    if ! $ldap_auth_passwd {
      fail("You require a LDAP password")
    }

    concat::fragment {'ldap':
      target  => 'rubycas',
      content => template('pe_console_auth/ldap.erb'),
      order   => find_index($order, 'ldap'),
    }
  }

  if $ad_enable {

    if ! $ad_host {
      fail("You require a host for the AD authenticator")
    }

    if ! $ad_base {
      fail("You require a port number for the AD authenticator")
    }

    if ! $ad_filter {
      fail("You require a filter for the AD authenticator")
    }

    if ! $ad_auth_user {
      fail("You require a user for the AD authenticator")
    }

    if ! $ad_auth_passwd {
      fail("You require a password for the AD authenticator")
    }

    concat::fragment {'ad':
      target => 'rubycas',
      content => template('pe_console_auth/ad.erb'),
      order   => find_index($order, 'ad'),
    }
  }

  concat::fragment {'end':
    target  => 'rubycas',
    content => template('pe_console_auth/end.erb'),
    order   => 99,
  }
}
