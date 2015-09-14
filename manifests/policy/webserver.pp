class applypolicy::policy::webserver {
  include 'apachewrapper'
  include 'my_fw'
  include nfsclient
  ensure_resource (  file , '/network' , {"ensure" => "directory" } )
  ensure_resource (  file , '/network/web' , {"ensure" => "directory" } )
}

