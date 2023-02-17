{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./accounts.nix
      ./clipboard.nix
      ./git.nix
      ./neovim
      ./security.nix
      ./readline.nix
      ./secrets.nix
      ./shellAliases.nix
    ];

  home.packages = with pkgs; [
    binutils
    cmake
    coreutils-full # installs gnu versions
    curl
    dtrx # Do The Right Extraction
    du-dust
    fd
    gawk
    gnugrep
    gnumake
    gnused
    gnutar
    gnutls
    gzip
    moreutils
    neofetch
    pinentry
    procs
    rcm
    ripgrep
    rlwrap
    sd
    silver-searcher
    sops
    tree
    unzip
    xh
    zenith
    zip
  ] ++ lib.options pkgs.stdenv.isLinux [
    cached-nix-shell
    sysz
    trash-cli
    (writeShellScriptBin ''capslock'' ''${xdotool} key Caps_Lock'')
    (writeShellScriptBin ''CAPSLOCK'' ''${xdotool} key Caps_Lock'') # just in case ;)
  ];

  home.sessionVariables = {
    DOCKER_SCAN_SUGGEST = "false";
    DO_NOT_TRACK = "1";
    HOMEBREW_NO_ANALYTICS = "1";
    NEXT_TELEMETRY_DISABLED = "1";
  };

  home.sessionPath = [
    "$HOME/.dotfiles/bin"
    "$HOME/.dotfiles/local/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
    "$HOME/.krew/bin"
    "$HOME/go/bin"
  ];

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  programs.btop.enable = true;

  programs.command-not-found.enable = !config.programs.nix-index.enable;

  programs.nix-index.enable = lib.mkDefault false;

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
        ];
      };
    };
  };

  programs.go.enable = true;

  programs.gpg.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    tmux.enableShellIntegration = config.programs.tmux.enable;
  };

  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = 1;
      show_program_path = 1;
      show_cpu_usage = 1;
      show_cpu_frequency = 0;
      show_cpu_temperature = 1;
      degree_fahrenheit = 0;
      enable_mouse = 1;
      tree_view = 0;
    };
  };

  programs.jq.enable = true;

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.tealdeer.enable = true; # tldr command

  # requires systemd
  services.gpg-agent = {
    enable = pkgs.stdenv.isLinux;
    enableSshSupport = true;
    defaultCacheTtl = lib.mkDefault 86400;
    maxCacheTtl = lib.mkDefault 86400;
    extraConfig = ''
      allow-emacs-pinentry
      allow-loopback-pinentry
    '';
  };

}
