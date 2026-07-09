{ lib, nixosConfigurations, homeConfigurations }:

with lib;

# Property tests that check critical configuration values are set correctly
{
  # NixOS Configuration Property Tests

  # Test that firewall is enabled on all systems
  testFirewallEnabled =
    let
      allConfigs = attrNames nixosConfigurations;
      checkFirewall = name:
        nixosConfigurations.${name}.config.networking.firewall.enable or false;
    in
    all checkFirewall allConfigs;

  # Test that NetworkManager is enabled on all systems
  testNetworkManagerEnabled =
    let
      allConfigs = attrNames nixosConfigurations;
      checkNM = name:
        nixosConfigurations.${name}.config.networking.networkmanager.enable or false;
    in
    all checkNM allConfigs;

  # Test that nix flakes are enabled on all systems
  testNixFlakesEnabled =
    let
      allConfigs = attrNames nixosConfigurations;
      checkFlakes = name:
        let
          features = nixosConfigurations.${name}.config.nix.settings.experimental-features or [];
        in
        elem "flakes" features && elem "nix-command" features;
    in
    all checkFlakes allConfigs;

  # Test that pip is enabled on all systems
  testPipewireEnabled =
    let
      allConfigs = attrNames nixosConfigurations;
      checkPipewire = name:
        nixosConfigurations.${name}.config.services.pipewire.enable or false;
    in
    all checkPipewire allConfigs;

  # Test that pulseaudio is disabled (we use pipewire)
  testPulseaudioDisabled =
    let
      allConfigs = attrNames nixosConfigurations;
      checkPulseaudio = name:
        !(nixosConfigurations.${name}.config.services.pulseaudio.enable or true);
    in
    all checkPulseaudio allConfigs;

  # Home Manager Configuration Property Tests

  # Test that neovim is enabled in home manager
  testNeovimEnabled =
    let
      allConfigs = attrNames homeConfigurations;
      checkNeovim = name:
        homeConfigurations.${name}.config.programs.neovim.enable or false;
    in
    all checkNeovim allConfigs;

  # Test that neovim is set as default editor
  testNeovimDefaultEditor =
    let
      allConfigs = attrNames homeConfigurations;
      checkDefaultEditor = name:
        homeConfigurations.${name}.config.programs.neovim.defaultEditor or false;
    in
    all checkDefaultEditor allConfigs;

  # Test that bash is enabled (chris uses bash)
  testBashEnabled =
    let
      checkBash = name:
        homeConfigurations.${name}.config.programs.bash.enable or false;
    in
    checkBash "chris";

  # Test that git is enabled
  testGitEnabled =
    let
      allConfigs = attrNames homeConfigurations;
      checkGit = name:
        homeConfigurations.${name}.config.programs.git.enable or false;
    in
    all checkGit allConfigs;

  # Test that critical programs are enabled for chris
  testChrisCriticalPrograms =
    let
      config = homeConfigurations.chris.config;
      criticalPrograms = [
        "bat"
        "btop"
        "jq"
        "ripgrep"
        "difftastic"
      ];
      checkProgram = prog: config.programs.${prog}.enable or false;
    in
    all checkProgram criticalPrograms;

  # Test that firefox is in home packages for chris
  testChrisHasFirefox =
    let
      packages = homeConfigurations.chris.config.home.packages;
      hasFirefox = any (pkg: pkg.pname or "" == "firefox") packages;
    in
    hasFirefox;

  # Test that essential CLI tools are available for chris
  testChrisEssentialCLI =
    let
      packages = homeConfigurations.chris.config.home.packages;
      packageNames = map (pkg: pkg.pname or "") packages;
      essentialTools = [ "curl" "fd" "yq" ];
      hasTool = tool: elem tool packageNames;
    in
    all hasTool essentialTools;

  # Test that home-manager itself is enabled
  testHomeManagerEnabled =
    let
      allConfigs = attrNames homeConfigurations;
      checkHM = name:
        homeConfigurations.chris.config.programs.home-manager.enable or false;
    in
    all checkHM allConfigs;

  # Hard-coded test: verify laptop systems have xserver enabled
  testLaptopsHaveXServer =
    let
      laptopConfigs = filter (name: hasPrefix "laptop-" name) (attrNames nixosConfigurations);
      checkXServer = name:
        nixosConfigurations.${name}.config.services.xserver.enable or false;
    in
    all checkXServer laptopConfigs;

  # Hard-coded test: verify WSL doesn't have desktop manager configured
  testWslNoDesktopManager =
    let
      wslConfigs = filter (name: hasPrefix "wsl-" name) (attrNames nixosConfigurations);
      checkNoDesktop = name:
        nixosConfigurations.${name}.config.desktopmanager.enable == null;
    in
    all checkNoDesktop wslConfigs;

  # Test that keyboard layout is set to dvorak variant
  testDvorakLayout =
    let
      xserverConfigs = filter (name:
        nixosConfigurations.${name}.config.services.xserver.enable or false
      ) (attrNames nixosConfigurations);
      checkDvorak = name:
        let
          xkb = nixosConfigurations.${name}.config.services.xserver.xkb;
        in
        (xkb.layout or "") == "us" && (xkb.variant or "") == "dvp";
    in
    length xserverConfigs == 0 || all checkDvorak xserverConfigs;
}
