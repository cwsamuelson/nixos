{ nixpkgs, nixosConfigurations }:

# Example NixOS VM integration test (optional)
# Uncomment and adapt to add to flake checks if needed

# nixpkgs.lib.nixosTest {
#   name = "basic-system-test";
#   
#   nodes.machine = { config, pkgs, ... }: {
#     imports = [
#       ../modules/shared
#       ../modules/nixos
#       ../hosts/base.nix
#     ];
#     
#     # Minimal test configuration
#     users.users.testuser = {
#       isNormalUser = true;
#       extraGroups = [ "wheel" ];
#     };
#   };
#   
#   testScript = ''
#     machine.wait_for_unit("multi-user.target")
#     
#     # Test that user exists
#     machine.succeed("id testuser")
#     
#     # Test that basic commands work
#     machine.succeed("systemctl --version")
#     
#     # Add your own tests here
#   '';
# }

# To enable, add this to your flake.nix checks:
# integration-test = import ./tests/integration-example.nix {
#   inherit nixpkgs nixosConfigurations;
# };
