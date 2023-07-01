{ config, pkgs, lib, ... }:

with lib;

{
  programs.rofi.terminal = "${config.programs.kitty.package}/bin/kitty";

  programs.kitty = {
    enable = true;

    theme = "kanagawabones";

    font = {
      package = pkgs.victor-mono;
      name = "Victor Mono";
      size = if pkgs.stdenv.isDarwin then 14 else 12;
    };

    # https://sw.kovidgoyal.net/kitty/actions/
    keybindings = {
      "ctrl+alt+1" = "goto_tab 1";
      "ctrl+alt+2" = "goto_tab 2";
      "ctrl+alt+3" = "goto_tab 3";
      "ctrl+alt+4" = "goto_tab 4";
      "ctrl+alt+5" = "goto_tab 5";
      "ctrl+alt+6" = "goto_tab 6";
      "ctrl+alt+7" = "goto_tab 7";
      "ctrl+alt+8" = "goto_tab 8";
      "ctrl+alt+9" = "goto_tab 9";
      "ctrl+alt+enter" = "launch --cwd=current";
      "kitty_mod+;" = "next_layout";
      "kitty_mod+down" = "neighboring_window down";
      "kitty_mod+enter" = "new_window_with_cwd";
      "kitty_mod+f3" = "kitten themes";
      "kitty_mod+h" = "neighboring_window left";
      "kitty_mod+j" = "neighboring_window down";
      "kitty_mod+k" = "neighboring_window up";
      "kitty_mod+l" = "neighboring_window right";
      "kitty_mod+left" = "neighboring_window left";
      "kitty_mod+n" = "new_os_window_with_cwd";
      "kitty_mod+right" = "neighboring_window right";
      "kitty_mod+t" = "new_tab_with_cwd";
      "kitty_mod+up" = "neighboring_window up";
      "kitty_mod+y>f" = "kitten hints --type path --program @";
      "kitty_mod+y>h" = "kitten hints --type hash --program @";
      "kitty_mod+y>l" = "kitten hints --type line --program @";
      "kitty_mod+y>w" = "kitten hints --type word --program @";
      "shift+super+w" = "close_os_window";
      "kitty_mod+/" = ''launch --type=overlay bash -i -c 'rg "^\s*(map|mouse_map)\s+.*" ~/.config/kitty/kitty.conf | fzf' '';
      "dynamic_background_opacity" = if pkgs.stdenv.isLinux then "on" else "off";
    };

    settings = {
      # Appearance
      window_padding_width = 5;
      hide_window_decorations = "titlebar-only";
      dim_opacity = "0.75";
      inactive_text_alpha = "0.75";
      disable_ligatures = "cursor"; # disable ligatures when cursor is on them
      cursor_shape = "Underline";
      cursor_underline_thickness = 1;

      # Behavior
      shell_integration = "enabled";
      allow_remote_control = false;
      confirm_os_window_close = 0;

      # Links
      url_style = "curly";
      detect_urls = true;
      open_url_with = "default";
      url_prefixes = "http https file ftp gemini irc gopher mailto news git";

      # Tab bar
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_bar_min_tabs = "2";
      tab_switch_strategy = "previous";
      tab_separator = " ┇";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
      tab_activity_symbol = "";

      # MacOS
      macos_titlebar_color = "background";
      macos_option_as_alt = "yes";
    };


    extraConfig = ''
      globinclude kitty.d/**/*.conf
    '';
  };

  home.packages = with pkgs; optionals config.xsession.windowManager.i3.enable [
    (writeShellScriptBin "kitty-floating" ''exec kitty --class kitty-floating "$@"'')
    (writeShellScriptBin "kitty-one" ''exec kitty --class kitty-one --single-instance "$@"'')
    (writeShellScriptBin "kitty-scratch" ''exec kitty --class kitty-scratch "$@"'')
    (writeShellScriptBin "x-terminal-emulator" ''exec kitty "$@"'')
  ];

  programs.zsh.initExtra = ''
    kitty + complete setup zsh | source /dev/stdin
  '';

  xsession.windowManager.i3.extraConfig = ''
    for_window [class="kitty-floating"] floating enable
    for_window [class="kitty-one"] floating enable, move position center, resize set 1600 1200
    for_window [class="kitty-scratch"] move scratchpad, scratchpad show
    bindsym $mod+Ctrl+Return exec kitty-one
  '';
}
