
class applypolicy::policy::localize_particle
{
    class {"cups": printernames => "DWBSharpL6", printerdriverdir => "puppet:///site_files/pp_local/ppd" }
}
