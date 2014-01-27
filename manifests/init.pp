define applypolicy (
    $policies= []
    )
{     
     tag("kickstart")
     applypolicy_impl{$policies:}
}
define applypolicy_impl ()
{
   $policy_name = "policy_$name"
   notify {"result is $policy_name ":}
   #create facts, this tells you what policies you expect to be aplied to help with debugging, if nothing else
   extfacter { $policy_name : value => "apply" }
   class {"applypolicy::policy::$name" : }
}
