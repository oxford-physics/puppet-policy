#this class is to hold all the  desktops, servers, interactive machines that are clients of the pp system
class applypolicy::policy::ppclient ($autodatalocation = $pp_client::params::autodatalocation )  inherits pp_client::params {

  include 'lustre_client'
  
  file { '/etc/auto.pplxfs':
      ensure  => present,
      source  => $autodatalocation,
      require => Package['autofs'],
      owner   => 'root',
      group   => 'root',
      mode    => '0444',
      notify => Service['autofs']
  }

  $map = '/etc/auto.pplxfs'
  $options_keys =['--timeout', '-g' ]
  $options_values  =[ '-120','']
  $dir = '/data'

   case $::augeasversion {
       '0.9.0','0.10.0', '1.0.0': { $lenspath = '/var/lib/puppet/lib/augeas/lenses' }
        default: { $lenspath = undef }
     }

#######################################
 #Pattern based on
 #http://projects.puppetlabs.com/projects/1/wiki/puppet_augeas

     augeas{"${dir}_edit":

       context   => '/files/etc/auto.master/',

       load_path => $lenspath,
       #This part changes options on an already existing line

      changes   => [
             "set *[map = '$map']     $dir",
             "set *[map = '$map']/map  $map",
             "set *[map = '$map']/opt[1] ${options_keys[0]}",
             "set *[map = '$map']/opt[1]/value ${options_values[0]}",
             "set *[map = '$map']/opt[2] ${options_keys[1]}",
        ]   ,
       notify    => Service['autofs']
     }
     augeas{"${dir}_change":
       context   => '/files/etc/auto.master/',
       load_path => $lenspath,
       #This part changes options on an already existing line
       changes   => [
             "set 01   /data",
             "set 01/map  /etc/auto.pplxfs",
             "set 01/opt[1] ${options_keys[0]}",
             "set 01/opt[1]/value ${options_values[0]}",
             "set 01/opt[2] ${options_keys[1]}",
        ]   ,
       onlyif    => "match *[map='/etc/auto.pplxfs'] size == 0",

       notify    => Service['autofs']
     }
}
#######################################


#}

