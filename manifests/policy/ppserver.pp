#this class is to hold all the  desktops, servers, interactive machines that are clients of the pp system
class applypolicy::policy::ppserver {

#Monitoring
  include "ganglia::client"
  include collectl

#Auth

  class { 'rsyslog' : }
  include nrpe

}
