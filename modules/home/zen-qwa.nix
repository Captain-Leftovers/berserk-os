# home/modules/zen-qwa.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  hasZen = (config.programs.zen-browser.enable or false);
  zenPkg = config.programs.zen-browser.package;
  # Pick the actual binary from the package (usually "zen"; change to "zen-browser" if yours differs)
  zenExe = lib.getExe' zenPkg "zen";
in
{
  assertions = [
    {
      assertion = hasZen;
      message = "zen-qwa.nix: programs.zen-browser.enable must be true (enable your Zen HM module first).";
    }
  ];

  # 1) Desktop entry QWA can detect (marked as WebBrowser)
  xdg.desktopEntries.zen-qwa = {
    name = "Zen Browser";
    genericName = "Web Browser";
    comment = "Firefox-based Zen browser";
    exec = "${zenExe} %u"; # QWA passes URL to %u
    terminal = false;
    type = "Application";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "text/html"
      "application/xhtml+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    startupNotify = true;
  };

  # 2) Make sure the desktop DB is refreshed after HM writes files
  home.activation.refreshDesktopDb = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.desktop-file-utils}/bin/update-desktop-database "${config.xdg.dataHome}/applications" || true
  '';

  # 3) Flatpak bits: add Flathub, install QWA, and grant it read access to desktop files
  home.activation.qwaSetup = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if command -v flatpak >/dev/null 2>&1; then
      # Add Flathub remote once (idempotent)
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

      # Install Quick Web Apps if missing (idempotent, non-interactive)
      if ! flatpak info dev.heppen.webapps >/dev/null 2>&1; then
        flatpak install -y --noninteractive flathub dev.heppen.webapps || true
      fi

      # Grant QWA read-only access to your desktop entries (idempotent)
      flatpak override dev.heppen.webapps \
        --filesystem="${config.xdg.dataHome}/applications:ro" \
        --filesystem="${config.home.profileDirectory}/share/applications:ro" \
        --filesystem="/run/current-system/sw/share/applications:ro" || true
    fi
  '';
}
