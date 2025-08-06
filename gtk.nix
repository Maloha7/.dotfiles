{inputs, ...}: {
  imports = [inputs.catppuccin.homeModules.catppuccin];
  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      flavor = "mocha";
      accent = "pink";
      size = "standard";
      tweaks = [ "normal" ];
    };
  };
}
