#this class is for all desktops, servers, interactive machines that are for users in the physics dept that connect to shared drives
class applypolicy::policy::staticclient ( 
$autonetworkhomelocation = hiera('applypolicy::policy::staticclient::autonetworkhomelocation',''),
$autonetworksoftwarelocation = hiera('applypolicy::policy::staticclient::autonetworksoftwarelocation',''),
$autoweblocation = hiera('applypolicy::policy::staticclient::autoweblocation',''),
$nfsservice = hiera('applypolicy::policy::staticclient::nfsservice','stopped'),
$nfsreaderkeytab = hiera("applypolicy::policy::staticclient::nfsreaderkeytab", "puppet:///modules/${module_name}/krb5.keytab.nfsreader" ),
$sysconfignfs = hiera("applypolicy::policy::staticclient::sysconfignfs", "puppet:///modules/$module_name/sysconfig.nfs" ),
$autodatalocation = hiera("applypolicy::policy::staticclient::autodatalocation", 'puppet:///site_files/generated_files/auto.data.npldecs' ),
$autogrouplocation = hiera("applypolicy::policy::staticclient::autogrouplocation", 'puppet:///site_files/generated_files/auto.group.server.physics.ox.ac.uk' ),
$autogroupparticleloaction = hiera("applypolicy::policy::staticclient::autogroupparticlelocation", 'puppet:///site_files/generated_files/auto.group.particle.server.physics.ox.ac.uk' ),
$autoel5location = hiera("applypolicy::policy::staticclient::autoel5location", 'puppet:///site_files/generated_files/auto.el5.npldecs' ),
$el5chrootmounts = hiera("applypolicy::policy::staticclient::el5chrootmounts", false),
$autoubuntupreciselocation = hiera("applypolicy::policy::staticclient::autoubuntupreciselocation", 'puppet:///site_files/generated_files/auto.ubuntu_precise.npldecs' ),
$ubuntuprecisechrootmounts = hiera("applypolicy::policy::staticclient::ubuntuprecisechrootmounts", false),
$autoubuntutrustylocation = hiera("applypolicy::policy::staticclient::autoubuntutrustylocation", 'puppet:///site_files/generated_files/auto.ubuntu_trusty.npldecs' ),
$ubuntutrustychrootmounts = hiera("applypolicy::policy::staticclient::ubuntutrustychrootmounts", false),
 ) {
realize Service['autofs']
include 'common'
#mounts
include 'yumbase'
include "access::access_wrapper"
#Why not? it makes everything consistent
include 'gridrepo'
include 'ssh'

ensure_packages ( ['nfs-utils','autofs'] )

ensure_resource('file', '/var/run/shm', {'ensure' => directory })
ensure_resource('file', '/data', {'ensure' => 'directory' })
if str2bool("$el5chrootmounts"){
  ensure_resource('file', '/chroots', {'ensure' => 'directory' })
  ensure_resource('file', '/chroots/el5', {'ensure' => 'directory', require => File['/chroots'],  })
  autofs::automount{ autoel5: dmap=>"/etc/automount/auto.el5", ddir=>"/chroots/el5", mapsource=>"$autoel5location"}
}
if str2bool("$ubuntuprecisechrootmounts"){
  ensure_resource('file', '/chroots', {'ensure' => 'directory' })
  ensure_resource('file', '/chroots/ubuntu_precise', {'ensure' => 'directory', require => File['/chroots'],  })
  autofs::automount{ autoubuntuprecise: dmap=>"/etc/automount/auto.ubuntu_precise", ddir=>"/chroots/ubuntu_precise", mapsource=>"$autoubuntupreciselocation"}
}

if str2bool("$ubuntutrustychrootmounts"){
  ensure_resource('file', '/chroots', {'ensure' => 'directory' })
  ensure_resource('file', '/chroots/ubuntu_trusty', {'ensure' => 'directory', require => File['/chroots'],  })
  autofs::automount{ autoubuntutrusty: dmap=>"/etc/automount/auto.ubuntu_trusty", ddir=>"/chroots/ubuntu_trusty", mapsource=>"$autoubuntutrustylocation"}
}

ensure_resource('file', '/el5', {'ensure' => 'absent', force=>true })
ensure_resource ( 'file', "/etc/keytabs/", 
  { ensure => directory,
	 	 owner   => 'root',
      	  	 group   => 'root',
	     	 mode    => '0700',
  } 
)

ensure_resource ( 'file', "/network",
  {
	  ensure  => 'directory',
	  mode    => '0755',
	  owner   => 'root',
	  group   => 'root',
  } 
)

ensure_resource ( 'file', "/network/home",
   {
	  ensure  => 'directory',
	  mode    => '0755',
	  owner   => 'root',
	  group   => 'root',
          require => File ['/network']
   } 
)
ensure_resource ( 'file', "/network/software",
   {
	  ensure  => 'directory',
	  mode    => '2775',
	  owner   => 'root',
	  group   => '10016',
          require => File ['/network']
   } 
)




#Appears to be a common problem that puppet cant create a directory with the correct permissions only if it does not exist.
#When I mount this dir, the owner and perms change, so puppet cannot manage these except through facters I guess


  include nfsclient

  augeas { "tunenfs":
  context => "/files/etc/sysctl.conf",
  changes => "set [. = /net.core.wmem_max] 2191361",
  }

  file { '/etc/sysconfig/nfs' :
     ensure => 'present',
     source => $sysconfignfs,
     require => Package['nfs-utils'],
     owner   => 'root',
     group   => 'root',
     mode    => '0444',
     notify => Service['nfs']
     }

  ensure_packages ( ['nfs-utils'] )

    service { 'nfs':
    name       => 'nfs',
    ensure     => $nfsservice,
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
  ensure_resource ( 'file' , "/etc/automount",
   {
          ensure  => 'directory',
          mode    => '0755',
          owner   => 'root',
          group   => 'root',
   }
  )
autofs::automount{ autonetworksoftware: dmap=>"/etc/automount/auto.network.software", ddir=>"/-", mapsource=>"$autonetworksoftwarelocation"}
autofs::automount{ autonetworkweb: dmap=>"/etc/automount/auto.web.server.physics.ox.ac.uk", ddir=>"/network/web", mapsource=>"$autoweblocation"}
autofs::automount{ autonetworkhome: dmap=>"/etc/automount/auto.network.home", ddir=>'/network/home', mapsource=>"$autonetworkhomelocation" }
autofs::automount{ autonetworkgroup: dmap=>"/etc/automount/auto.group", ddir=>'/network/group', mapsource=>"$autogrouplocation" }
autofs::automount{ autodata: dmap=>"/etc/auto.data", ddir=>'/data', mapsource=>"$autodatalocation" }


file {'/etc/keytabs/krb5.keytab.nfsreader':
          source => $nfsreaderkeytab,
          mode => 0600,
          owner => root,
          group=>root,
          ensure=>present,
          require=> File['/etc/keytabs/']
}

}
