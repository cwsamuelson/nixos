{ pkgs, config, stateVersion, username, system, init-bash, ... }:
let
  userScripts = pkgs.runCommand "apps" {} ''
    mkdir -p $out
    echo "#!/usr/bin/env bash" > $out/my-script
    echo "echo hello from my script!" >> $out/my-script
    chmod +x $out/my-script
  '';

  # add dep to makeWrapper some how?
  #nativeBuildInputs = [ pkgs.makeWrapper ];
  fullWrapped = pkgs.runCommand "wrapped-apps" {} ''
    mkdir -p $out/bin
    cp -r ${init-bash.packages.${system}.default}/bin/* $out/bin
    cp -r ${init-bash.packages.${system}.default}/bin/.init.bash-wrapped $out/bin
    rm $out/bin/init.bash
    mv $out/bin/.init.bash-wrapped $out/bin/init.bash

    # re-wrap the original
    # maybe the flake doesn't need to wrap to begin with?
    wrapProgram $out/bin/init.bash \
      --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.bash ]}

    mkdir -p $out/bin/apps
    cp -r ${userScripts}/* $out/bin/apps
  '';
in
{
  imports = [
    ./modules
    ./packages.nix
  ];

  config._module.args = {
    inherit username stateVersion fullWrapped;
  };
}
