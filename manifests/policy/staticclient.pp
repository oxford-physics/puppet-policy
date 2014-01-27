#this class is for all desktops, servers, interactive machines that are for users in the physics dept that connect to shared drives
class applypolicy::policy::staticclient {

include 'common'
#mounts
include 'yumbase'
include "access::access_wrapper"
#Why not? it makes everything consistent
include 'gridrepo'

#this line can go in as many times as you like
ensure_packages ( ['nfs-utils','autofs'] )


include 'ssh'

@file { '/network' :
  ensure  => 'directory',
  mode    => '0744',
  owner   => 'root',
  group   => 'root',
  }

#Appears to be a common problem that puppet cant create a directory with the correct permissions only if it does not exist.
#When I mount this dir, the owner and perms change, so puppet cannot manage these except through facters I guess


  include nfsclient
  realize(File["/network"])

  augeas { "tunenfs":
  context => "/files/etc/sysctl.conf",
  changes => "set [. = /net.core.wmem_max] 2191361",
  }

  file { '/etc/sysconfig/nfs' :
     ensure => 'present',
     source => "puppet:///modules/$module_name/sysconfig.nfs",
     require => Package['nfs-utils'],
     owner   => 'root',
     group   => 'root',
     mode    => '0444',
     notify => Service['nfs']
     }

  ensure_packages ( ['nfs-utils'] )

    service { 'nfs':
    name       => 'nfs',
    ensure     => stopped,
    enable     => false,
    hasrestart => true,
    hasstatus  => true,
    require => Package['nfs-utils']
  }

    service { 'nfslock':
    name       => 'nfslock',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require => Package['nfs-utils']
  }
 file { '/network/home':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
  }

  file { '/etc/auto.home':
      ensure  => present,
      source  => $autohomelocation,
      require => Package['autofs'],
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      notify    => Service['autofs']
  }

  $map = '/etc/auto.home'
  $options_keys =['--timeout', '-g' ]
  $options_values  =[ '-120','']
  $dir = '/network/home'

 #Pattern based on
 #http://projects.puppetlabs.com/projects/1/wiki/puppet_augeas

     augeas{"home_edit":

       context   => '/files/etc/auto.master/',

       load_path => $lenspath,
       #This part changes options on an already existing line

      changes   => [
             "set *[map = '$map']     $dir",
             "set *[map = '$map']/map  $map",
             "set *[map = '$map']/opt[1] ${options_keys[0]}",
             "set *[map = '$map']/opt[1]/value ${options_values[0]}",
             "set *[map = '$map']/opt[2] ${options_keys[1]}",
     #        "set *[map = '$map']/opt[2]/value ${options_values[1]}",
        ]   ,
       notify    => Service['autofs']
     }
     augeas{"home_change":
       context   => '/files/etc/auto.master/',
       load_path => $lenspath,
       #This part changes options on an already existing line
       changes   => [
             "set 01   $dir",
             "set 01/map  /etc/auto.home",
             "set 01/opt[1] ${options_keys[0]}",
             "set 01/opt[1]/value ${options_values[0]}",
             "set 01/opt[2] ${options_keys[1]}",
    #         "set 01/opt[2]/value ${options_values[1]}",
        ]   ,
       onlyif    => "match *[map='/etc/auto.home'] size == 0",

       notify    => Service['autofs']
     }

}
