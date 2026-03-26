{
  config,
  lib,
  pkgs,
  ...
}: {
  services.onlyoffice = {
    enable = true;
  };
}
