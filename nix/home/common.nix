{ config, lib, pkgs, ... }:

let
in
{
  imports = [
    ../modules/nix-registry.nix
    ./accounts.nix
    ./clipboard.nix
    ./common-linux.nix
    ./fzf.nix
    ./git
    ./gpg.nix
    ./neovim
    ./nix-path.nix
    ./ranger.nix
    ./readline.nix
    ./secrets.nix
    ./security.nix
    ./shell
  ];

  home.packages = with pkgs; [
    bc
    binutils
    cmake
    coreutils-full # installs gnu versions
    curl
    dig
    dogdns # dig on steroids
    du-dust # du alternative
    duf # df alternative
    envsubst
    fd
    gawk
    gnugrep
    gnumake
    gnused
    gnutar
    gnutls
    gzip
    lsof
    moreutils
    neofetch
    pinentry
    procs # ps alternative
    rlwrap
    sd # sed alternative
    sops
    tree
    unzip
    xh # curl alternative
    zip
  ];

  home.sessionVariables = {
    DOCKER_SCAN_SUGGEST = "false";
    DOTNET_CLI_TELEMETRY_OPTOUT =  "true";
    DO_NOT_TRACK = "1";
    TELEMETRY_DISABLED = "1";
    DISABLE_TELEMETRY = "1";
  };

  home.sessionPath = [
    "${config.my.dotfilesDir}/bin"
    "${config.my.dotfilesDir}/local/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.krew/bin"
    "$HOME/go/bin"
  ];

  programs.home-manager.enable = true;

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "onedark";
      theme_background = false;
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    nix-direnv.enable = true;
    config = {
      global = {
        warn_timeout = "10s";
      };
      whitelist = {
        prefix = [
          "${config.home.homeDirectory}/.dotfiles"
          "${config.home.homeDirectory}/src/github.com/loganlinn"
        ];
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = config.programs.tmux.enable;
  };

  programs.ripgrep = {
    enable = true;
    arguments = [
      "--type-add"
      "clj:include:clojure,edn"
      "--smart-case"
    ];
  };

  programs.jq.enable = true;

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.tealdeer.enable = true; # tldr command
}
