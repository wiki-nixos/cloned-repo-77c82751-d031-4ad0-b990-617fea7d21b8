{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "emacs";
    sessionVariables = {EDITOR = "vim";};
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
      path = "${config.xdg.dataHome}/zsh/history";
      share = false;
      size = 100000;
      save = 100000;
    };
    dirHashes = {
      cfg = "$HOME/.config";
      nix = "$HOME/.dotfiles/nix";
      dot = "$HOME/.dotfiles";
      docs = "$HOME/Documents";
      dl = "$HOME/Downloads";
      src = "$HOME/src";
      gh = "$HOME/src/github.com";
      patch-tech = "$HOME/src/github.com/patch-tech";
      patch = "$HOME/src/github.com/patch-tech/patch";
    };
    initExtra = ''
      . ~/.dotfiles/bin/src-get
    '';
  };
}
