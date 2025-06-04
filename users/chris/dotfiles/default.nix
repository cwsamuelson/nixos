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

    emptyDir = pkgs.runCommand "empty-dir" {} ''
      mkdir -p $out
    '';
in
{
  home.file = generatedFiles // {
    "init-bash/apps".source = emptyDir;

    #".screenrc".source = ./screenrc;
    ".inputrc".source = ./inputrc;
  };
}
