repo: { pkgs, lib, config, ... }: # pass repo via extraSpecialArgs
let cfg = config.vim; in { 
  imports = [];

  options.vim = with lib; {
    enable = mkEnableOption "nvim";
    
    enableLatexSuite = mkEnableOption "LaTeX Suite";

    defaultEditor = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to configure nvim as the default editor via
      the EDITOR environment variable.";
    };

    vimAlias = mkOption {
      type = types.bool;
      default = false;
      description = "Symlink vim to nvim binary.";
    };

    textWidth = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = "The textwidth to set.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim.enable = true;
    
    programs.neovim.defaultEditor = cfg.defaultEditor;
    programs.neovim.vimAlias = cfg.vimAlias;
    programs.neovim.extraConfig = 
      if cfg.textWidth != null then 
        "set tw=${builtins.toString(cfg.textWidth)}"
      else
        "";

    home.file.".config/nvim" = {
      recursive = true;
      source = "${repo}/.config/nvim";
    };
  
    programs.neovim.extraPackages = let 
      vimPackages = [
        pkgs.ripgrep
      ];
      latexPackages = with pkgs; [
        sioyek
        texlive.combined.scheme-full
        texlab
        tectonic
      ]; 
    in if cfg.enableLatexSuite then
      vimPackages ++ latexPackages
    else
      vimPackages;
  };
}
