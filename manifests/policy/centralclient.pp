#this class is to hold all the  desktops, servers, interactive machines that are clients of the pp system
class applypolicy::policy::centralclient (
$autohomelocation=hiera("applypolicy::policy::centralclient::autohomelocation",""),
$autostatichomelocation=hiera("applypolicy::policy::centralclient::autohomelocation",""),
)
{
  realize Service['autofs']

  file {'/usr/local/bin/newnode-test.sh' :
          source => "puppet:///modules/${module_name}/newnode-test.sh.central",
          mode => 0755,
          owner => root,
          group=>root,
          ensure=>present
  }

ensure_resource ( 'file', "/etc/automount",
  {
          ensure  => 'directory',
          mode    => '0755',
          owner   => 'root',
          group   => 'root',
  }
)
define autohome($autohomelocation = '',
             $autostatichomelocation = '' 
)
  {

  notify{"$autohomelocation is loc":}
  if ( $autostatichomelocation)
  {
    file { '/etc/automount/auto.home.physics.ox.ac.uk':
      ensure  => present,
      source  => $autostatichomelocation,
      require => Package['autofs'],
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
    }
  }

  file { '/etc/automount/auto.home':

      ensure  => present,
      source  => $autohomelocation,
      require => Package['autofs'],
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      notify    => Service['autofs']
  }


  $hmap = '/etc/automount/auto.home'
  $options_keys =['--timeout', '-g' ]
  $options_values  =[ '-120','']
  $hdir = '/home'

 #Pattern based on
 #http://projects.puppetlabs.com/projects/1/wiki/puppet_augeas

     augeas{"${name}_edit":

       context   => '/files/etc/auto.master/',

       load_path => $lenspath,
       #This part changes options on an already existing line

      changes   => [
             "set *[map = '$hmap']     $hdir",
             "set *[map = '$hmap']/map  $hmap",
             "set *[map = '$hmap']/opt[1] ${options_keys[0]}",
             "set *[map = '$hmap']/opt[1]/value ${options_values[0]}",
             "set *[map = '$hmap']/opt[2] ${options_keys[1]}",
     #        "set *[map = '$hmap']/opt[2]/value ${options_values[1]}",
        ]   ,
       notify    => Service['autofs']
     }

     augeas{"${name}_change":
       context   => '/files/etc/auto.master/',
       load_path => $lenspath,
       #This part changes options on an already existing line
       changes   => [
             "set 01   $hdir",
             "set 01/map  ${hmap}",
             "set 01/opt[1] ${options_keys[0]}",
             "set 01/opt[1]/value ${options_values[0]}",
             "set 01/opt[2] ${options_keys[1]}",
    #         "set 01/opt[2]/value ${options_values[1]}",
        ]   ,
       onlyif    => "match *[map='/etc/automount/auto.home'] size == 0",

       notify    => Service['autofs']
     }

 }

autohome { autohome : 
           autostatichomelocation=>$autostatichomelocation ,
           autohomelocation=>$autohomelocation }
}

