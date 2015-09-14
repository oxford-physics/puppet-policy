#this class is to hold all the  desktops, servers, interactive machines that are clients of the pp system
class applypolicy::policy::ppsoftware {

 #HEP OS Libs at least
 include 'gridrepo'

 include user_software::pp_base
 include 'motd'
 if ec2_metadata == undef  {
   ensure_packages ( ["OpenIPMI"] )
 }

 file { '/etc/cvmfs' : ensure => directory,      owner   => 'root',
      group   => 'root',      mode    => '0755',
 }
 file { '/etc/cvmfs/keys/' : ensure => directory,      owner   => 'root',
      group   => 'root',      mode    => '0755',
      require => File['/etc/cvmfs/']
 }


  file { '/etc/cron.daily/cvmfs_fsck.sh': 
         source => 'puppet:///site_files/pp_local/cvmfs_fsck.sh',
         owner   => 'root',
         group   => 'root',
         mode    => '0744',
         ensure => present,
  }

}
