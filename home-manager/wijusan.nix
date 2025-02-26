{ config, pkgs, lib, nix-colors, ... }:

{
  imports = [
    ../nix/home/dev/nix.nix
    ../nix/home/dev/nodejs.nix
    ../nix/home/dev/shell.nix
    ../nix/home/dev/lua.nix
    ../nix/home/emacs
    ../nix/home/home-manager.nix
    ../nix/home/pretty.nix
    ../nix/home/yt-dlp.nix
    ../nix/modules/spellcheck.nix
  ];

  colorScheme = nix-colors.colorSchemes.doom-one; # needed?

  # my.java.package = pkgs.jdk17;
  # my.java.toolchains = with pkgs; [ jdk8 jdk11 ];
  modules.spellcheck.enable = true;

  # Configure Git to use ssh.exe (1Password agent forwarding)
  # https://developer.1password.com/docs/ssh/integrations/wsl/
  programs.git.extraConfig = {
    user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINGpyxX1xNYCJHLpTQAEorumej3kyNWlknnhQ/QqkhdN";
    gpg.format = "ssh";
    gpg.ssh.program = "/mnt/c/Users/logan/AppData/Local/1Password/app/8/op-ssh-sign-wsl";
    commit.gpgsign = true;
  };

  programs.emacs.enable = true;
  programs.emacs.package = pkgs.emacs-pgtk; # native Wayland support
  services.emacs.enable = true;

  # programs.nix-index.enable = false;
  # programs.nix-index.enableZshIntegration = config.programs.nix-index.enable;

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  my.astronvim.enable = false;

  home.packages = with pkgs; [
    wslu
    trashy
    micromamba
  ];
  home.username = "logan";
  home.homeDirectory = "/home/logan";
  home.stateVersion = "22.11";

  nix.enable = true;
  nix.package = pkgs.nixVersions.stable;
  nix.settings = {
    trusted-users = [ "root" config.home.username ];
    experimental-features = [ "nix-command" "flakes" "repl-flake" ];
    warn-dirty = false;
    accept-flake-config = true;
    run-diff-hook = true;
    show-trace = true;
  };
}
