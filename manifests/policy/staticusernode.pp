#this class is for all desktops, servers, interactive machines that are for users in the physics dept to run programs on (not necessarily log on to)
class applypolicy::policy::staticusernode {
  include user_software::common
  case $operatingsystem {
             /Scientific/: {

        class { 'afs::client' : }

       }
             /CentOS/: {

        class { 'afs::client' : }

       }
   }
   include cvmfs_simple

}
