{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Add your packages here
    opencode
  ];

  opencode = {
    enable = true;
  };
}
