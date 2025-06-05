{ pkgs, init-bash, ... }:
let
  skipList = [
    "LICENSE"
    "README.md"
    "apps/app1"
  ];

  # recursively walk directory tree
  collectFiles = basePath: relPath:
    let
      fullPath = "${basePath}/${relPath}";
      entries = builtins.readDir fullPath;
      paths = builtins.attrNames entries;
    in builtins.concatLists (builtins.map (name:
      let
        type = entries.${name};
        subPath = if relPath == "" then name else "${relPath}/${name}";
      in
        if builtins.elem subPath skipList then
          [] # skip files and directories
        else if type == "directory" then
          collectFiles basePath subPath
        else if type == "regular" then
          [{
            name = "init-bash/${subPath}";
            value.source = "${basePath}/${subPath}";
          }]
        else
          [] # fallback; symlinks?
  ) paths);

  generatedFiles = builtins.listToAttrs (collectFiles init-bash "");

  test-script = pkgs.stdenv.mkDerivation {
    name = "script";
    src = ./.;
    #${init-bash.packages.${system}.default}
    #src = fetchurl {
    #  url = https://github.com/binaryphile/init.bash;
    #  sha256 = "...";
    #};

    installPhase = ''
      mkdir -p $out/bin
      cp test_script $out/bin
    '';
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
in
pkgs.runCommand "home-scripts" {} ''
  mkdir -p $out/bin/apps
  mkdir -p $out/bin/bin
  mkdir -p $out/bin/lib
  mkdir -p $out/bin/settings

  cp -r ${test-script}/bin/* $out/bin/bin

  cp -r ${init-bash-scripts}/bin/* $out/bin
  #cp -r ${init-bash-scripts}/bin/bin $out/bin
  #cp -r ${init-bash-scripts}/bin/lib $out/bin
  #cp -r ${init-bash-scripts}/bin/settings $out/bin
''
