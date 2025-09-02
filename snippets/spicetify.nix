{ pkgs, inputs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in { 
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicePkgs.extensions; [
      trashbin
      history
      playNext
    ];
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];
    theme = spicePkgs.themes.hazy;
  };
}
