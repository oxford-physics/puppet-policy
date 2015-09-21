class applypolicy::policy::interactive
{

  ensure_packages ( ['fuse'] )
  include user_software::interactive
  include user_software::remote_connection

  file {'/bin/fusermount':
         require => Package ['fuse'],
         mode=>4755,
         owner=>root,
         group=>fuse,
         ensure=>present

        }

  $admin_package_list = [ "cifs-utils", "samba-common", "samba", "krb5-workstation" ]
  ensure_packages ( $admin_package_list  )

}

