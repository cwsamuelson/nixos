{ pkgs, ... }:
let
  init-bash = pkgs.fetchFromGitHub {
    owner = "binaryphile";
    repo = "init.bash";
    rev = "664cd8302c7882cb8f3d7d91c4c5ae68611030d0";
    sha256 = "sha256-WDpOgfOsJEvitGShzZmLOWc+OVY3JvIJDdV0VBbYODs=";
  };

  init-bash-scripts = pkgs.stdenv.mkDerivation {
    name = "init-bash-scripts";
    src = init-bash;

    installPhase = ''
      mkdir -p $out/bin/bin
      mkdir -p $out/bin/apps
      mkdir -p $out/bin/lib
      mkdir -p $out/bin/settings

      cp ./init.bash $out/bin/init.bash
      cp -r lib $out/bin
      cp -r settings $out/bin

      #chmod -R +x $out/*.bash
      #chmod +x $out/bin/init.bash
      #chmod +x $out/bin/bin/*
      #chmod +x $out/bin/lib/*
      #chmod +x $out/bin/settings/*
    '';
  };

  test-script = pkgs.stdenv.mkDerivation {
    name = "test-script";
    src = ./.;

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/bin/settings

      cp -r settings $out/bin

      chmod +x settings/*
    '';
  };
in
pkgs.runCommand "home-scripts" {} ''
  mkdir -p $out/bin/apps
  mkdir -p $out/bin/bin
  mkdir -p $out/bin/lib
  mkdir -p $out/bin/settings

  cp -r ${init-bash-scripts}/bin/lib/* $out/bin/lib
  cp -r ${init-bash-scripts}/bin/init.bash $out/bin

  cp ${test-script}/bin/settings/* $out/bin/settings
''
