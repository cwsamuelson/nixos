# https://ayats.org/blog/no-flake-utils
{
  description = "Basic flake for configuration of my NixOS and Home Manager environments";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixgl = {
    #   url = "github:nix-community/nixGL";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, ... }@inputs:
  with nixpkgs.lib;
  let
    system = "x86_64-linux";
    user_configs = import ./users/configs.nix;
    host_configs = import ./hosts/configs.nix;

    # Re-organizing based on:
    # https://github.com/Ev-Mu/home-manager
    makeSystem = hostname: username: host_config: user_config:
    let
      host = {
        inherit hostname;
      };

      user = {
        inherit (user_config)
          name
          email
          groups
        ;
        username = toLower (head (splitString " " user_config.name));
      };
    in
    nixosSystem {
      inherit system;

      specialArgs = {
        inherit inputs host user nixos-wsl;
      };

      modules = [
        ./modules/shared
        ./modules/nixos
        ./hosts/base.nix
        ./hosts/${hostname}/configuration.nix
      ];
    };

    # Generate all user×host combinations
    nixosConfigurations =
      let
        pairs = flatten (mapAttrsToList (hostname: host_config:
          mapAttrsToList (username: user_config: {
            name = "${hostname}-${username}";
            value = makeSystem hostname username host_config user_config;
          }) user_configs
        ) host_configs);
      in
      listToAttrs pairs;

    makeHM = profile: user_config:
    let
      user = {
        inherit (user_config)
          name
          email
          stateVersion
          groups
        ;
        username = toLower (head (splitString " " user.name));
      };
    in
    home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
        };
      };

      extraSpecialArgs = {
        inherit
          profile
          inputs
          user
          system
        ;
      };

      modules = [
        ./modules/shared
        ./modules/home-manager
        ./users/${user.username}
      ];
    };

    homeConfigurations = builtins.mapAttrs (profile: config: makeHM profile config) user_configs;

  in {
    inherit nixosConfigurations homeConfigurations;

    # Testing infrastructure
    checks.${system} =
      let
        pkgs = import nixpkgs { inherit system; };

        # Run unit tests
        unitTests = import ./tests/unit-tests.nix { inherit (pkgs) lib; };

        # Run config validation tests
        configTests = import ./tests/config-tests.nix {
          inherit (pkgs) lib;
          inherit nixpkgs user_configs host_configs nixosConfigurations homeConfigurations;
        };

        # Run property tests
        propertyTests = import ./tests/property-tests.nix {
          inherit (pkgs) lib;
          inherit nixosConfigurations homeConfigurations;
        };

        # Helper to create assertion checks
        makeAssertionCheck = name: condition: pkgs.runCommand "check-${name}" {} ''
          ${if condition then "echo 'PASS: ${name}'" else "echo 'FAIL: ${name}' && exit 1"}
          mkdir $out
        '';
      in
      {
        # Unit tests
        unit-tests = makeAssertionCheck "unit-tests" (unitTests == []);

        # Config validation tests - structure
        config-user-fields = makeAssertionCheck "config-user-fields" configTests.testUserConfigsValid;
        config-host-fields = makeAssertionCheck "config-host-fields" configTests.testHostConfigsValid;
        config-user-groups = makeAssertionCheck "config-user-groups" configTests.testUserGroupsValid;
        config-email-format = makeAssertionCheck "config-email-format" configTests.testUserEmailFormat;
        config-state-versions = makeAssertionCheck "config-state-versions" configTests.testStateVersionsAreStrings;

        # Config existence tests - automatic based on users/hosts
        config-nixos-exist = makeAssertionCheck "config-nixos-exist" configTests.testNixosConfigurationsExist;
        config-nixos-not-empty = makeAssertionCheck "config-nixos-not-empty" configTests.testNixosConfigurationsNotEmpty;
        config-home-exist = makeAssertionCheck "config-home-exist" configTests.testHomeConfigurationsExist;
        config-home-not-empty = makeAssertionCheck "config-home-not-empty" configTests.testHomeConfigurationsNotEmpty;
        config-all-hosts-present = makeAssertionCheck "config-all-hosts-present" configTests.testAllHostsHaveConfigurations;
        config-all-users-present = makeAssertionCheck "config-all-users-present" configTests.testAllUsersHaveConfigurations;

        # Config existence tests - hard-coded for chris (prevent empty state passing)
        config-wsl-chris = makeAssertionCheck "config-wsl-chris" configTests.testWslChrisExists;
        config-laptop-fw-chris = makeAssertionCheck "config-laptop-fw-chris" configTests.testLaptopFwChrisExists;
        config-laptop-ava-chris = makeAssertionCheck "config-laptop-ava-chris" configTests.testLaptopAvaChrisExists;
        config-chris-home = makeAssertionCheck "config-chris-home" configTests.testChrisHomeExists;
        config-minimum-nixos = makeAssertionCheck "config-minimum-nixos" configTests.testMinimumNixosConfigurations;

        # Property tests - verify critical configuration properties
        prop-firewall-enabled = makeAssertionCheck "prop-firewall-enabled" propertyTests.testFirewallEnabled;
        prop-networkmanager = makeAssertionCheck "prop-networkmanager" propertyTests.testNetworkManagerEnabled;
        prop-nix-flakes = makeAssertionCheck "prop-nix-flakes" propertyTests.testNixFlakesEnabled;
        prop-pipewire = makeAssertionCheck "prop-pipewire" propertyTests.testPipewireEnabled;
        prop-no-pulseaudio = makeAssertionCheck "prop-no-pulseaudio" propertyTests.testPulseaudioDisabled;
        prop-neovim = makeAssertionCheck "prop-neovim" propertyTests.testNeovimEnabled;
        prop-neovim-default = makeAssertionCheck "prop-neovim-default" propertyTests.testNeovimDefaultEditor;
        prop-bash = makeAssertionCheck "prop-bash" propertyTests.testBashEnabled;
        prop-git = makeAssertionCheck "prop-git" propertyTests.testGitEnabled;
        prop-chris-programs = makeAssertionCheck "prop-chris-programs" propertyTests.testChrisCriticalPrograms;
        prop-chris-firefox = makeAssertionCheck "prop-chris-firefox" propertyTests.testChrisHasFirefox;
        prop-chris-cli = makeAssertionCheck "prop-chris-cli" propertyTests.testChrisEssentialCLI;
        prop-home-manager = makeAssertionCheck "prop-home-manager" propertyTests.testHomeManagerEnabled;
        prop-laptops-xserver = makeAssertionCheck "prop-laptops-xserver" propertyTests.testLaptopsHaveXServer;
        prop-wsl-no-desktop = makeAssertionCheck "prop-wsl-no-desktop" propertyTests.testWslNoDesktopManager;
        prop-dvorak = makeAssertionCheck "prop-dvorak" propertyTests.testDvorakLayout;

        # Build checks - verify configurations evaluate without errors
        # Test that all nixosConfigurations can be built (just the config, not full system)
      } // (mapAttrs' (name: config:
        nameValuePair "nixos-config-${name}" config.config.system.build.toplevel
      ) nixosConfigurations)
      // (mapAttrs' (name: config:
        nameValuePair "home-config-${name}" config.activationPackage
      ) homeConfigurations);
  };
}
