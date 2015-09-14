#This class is purely a work around, so that I dont need to install cvmfs when I want to manage the autofs service

class applypolicy::policy::autofsnocvmfs {

  #package structure
  $package_list = [ 'autofs' ]

  ensure_packages ( $package_list )
$autofs_defaults = {
   'autofs' => {   'ensure'     => running,
               'hasstatus'  => true,
               'hasrestart' => true,
               'enable'     => true,
               'require'    => [Package['autofs']],
               'name' => 'autofs'
               }
}
if ! defined(Service['autofs']) {

@service { autofs : 
     ensure     => running,
               hasstatus  => true,
               hasrestart => true,
               enable     => true,
               require    => [Package['autofs']],
               name => 'autofs'          

}

realize Service['autofs']

}


}
