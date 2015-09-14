
class applypolicy::policy::localize_particle
{
    class {"cups": printernames => "DWBSharpL6", printerdriverdir => "puppet:///site_files/pp_local/ppd" }
    file { "/usr/local/lib/Cshrc":
           content => "setenv VO_LHCB_SW_DIR /cvmfs/lhcb.cern.ch
setenv VO_ATLAS_SW_DIR /cvmfs/atlas.cern.ch"
   }

}
