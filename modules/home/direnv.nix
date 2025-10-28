{ ... }:
{
  programs.zsh.enable = true;

  programs.direnv = {
    enable = true; # install + configure direnv
    nix-direnv.enable = true; # enables `use flake` and nix integration
    enableZshIntegration = true; # adds the shell hook for Zsh declaratively
  };
}
