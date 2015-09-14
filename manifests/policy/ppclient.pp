#this class is to hold all the  desktops, servers, interactive machines that are clients of the pp system
class applypolicy::policy::ppclient ()
{
  realize Service['autofs']
  #TODO, use a better fact to determine we dont want lustre
  if $ec2_metadata != undef {
  }
  else
  {
    include 'lustre_client'
  }
  file {'/usr/local/bin/newnode-test.sh' :
          source => "puppet:///modules/${module_name}/newnode-test.sh",
          mode => 0755,
          owner => root,
          group=>root,
          ensure=>present
  }

}

