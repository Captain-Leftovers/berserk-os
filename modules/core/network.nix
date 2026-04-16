{
  pkgs,
  host,
  options,
  ...
}: let
  inherit (import ../../hosts/${host}/variables.nix) hostId;
in {
  # Defensive assertion for hostname validity (clearer message at eval time)
  assertions = [
    {
      assertion = builtins.match "^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$" host != null;
      message = "Invalid hostname '${host}'. Must be 1-63 chars, start/end alphanumeric; allowed middle chars: letters, digits, '-' or '_'.";
    }
  ];

  networking = {
    hostName = "${host}";
    hostId = hostId;
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ ["pool.ntp.org"];
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # SSH
        # 80    # HTTP  — uncomment only if running a web server
        # 443   # HTTPS — uncomment only if running a web server
        59010 # Sunshine/Moonlight game streaming
        59011 # Sunshine/Moonlight game streaming
        # 8080  # Alt HTTP — uncomment only if needed
      ];
      allowedUDPPorts = [
        59010 # Sunshine/Moonlight game streaming
        59011 # Sunshine/Moonlight game streaming
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    # networkmanagerapplet
  ];
}
