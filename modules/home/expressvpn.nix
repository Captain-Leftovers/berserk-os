{ pkgs, ... }:

{
  # Not needed unless you want to run expressvpn commands at session start
  systemd.user.services.expressvpn-autoconnect = {
    Unit = {
      Description = "Auto-connect ExpressVPN";
      After = [ "default.target" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };

    Service = {
      ExecStart = "${pkgs.expressvpn}/bin/expressvpn connect smart";
      Restart = "on-failure";
    };
  };
}
