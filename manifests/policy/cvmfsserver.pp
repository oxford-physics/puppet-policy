class applypolicy::policy::cvmfsserver()
{
  class { cvmfs::server: 
          pubkey => 'physics.ox.ac.uk.pub.safe',
          repo   => "physics.ox.ac.uk"
  }
  #TODO
  #DETECT /var/spool/cvmfs file system is mounted with user_xattr
  #Find out why the scripts dont ADD FSTAB ENTRY
  #   cvmfs2#physics.ox.ac.uk /var/spool/cvmfs/physics.ox.ac.uk/rdonly fuse allow_other,config=/etc/cvmfs/repositories.d/physics.ox.ac.uk/client.conf:/var/spool/cvmfs/physics.ox.ac.uk/client.local,cvmfs_suid 0 0 # added by CernVM-FS for physics.ox.ac.uk
  #   aufs_physics.ox.ac.uk /cvmfs/physics.ox.ac.uk aufs br=/var/spool/cvmfs/physics.ox.ac.uk/scratch=rw:/var/spool/cvmfs/physics.ox.ac.uk/rdonly=rr,udba=none,ro, 0 0 # added by CernVM-FS for physics.ox.ac.uk
  
  #Increase open file limit
  #add "*          -       nofile   8192" to /etc/security/limits.d/90-nproc.conf
  
}
