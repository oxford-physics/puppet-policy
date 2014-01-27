#this class is to hold all the  desktops, servers, interactive machines that are clients of the pp system
class applypolicy::policy::ppsoftware {


 include cvmfs
 include user_software::pp_base
 include 'motd'


}
