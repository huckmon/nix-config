{ config, pkgs, inputs, ... }:

{

  environment.systemPackages = with pkgs; [
    kdePackages.kate
    nil
    dockerfile-language-server-nodejs
    bash-language-server
    typescript-language-server
    python312Packages.python-lsp-server
    gopls
  ];

}
