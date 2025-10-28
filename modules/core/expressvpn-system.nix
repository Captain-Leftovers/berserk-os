{ pkgs, ... }:

{
  # Add ExpressVPN to system packages
  environment.systemPackages = with pkgs; [ expressvpn ];

  # System service: ExpressVPN Daemon
  systemd.services.expressvpnd = {
    description = "ExpressVPN Daemon";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.expressvpn}/bin/expressvpnd";
      Restart = "always";
    };
  };
}
