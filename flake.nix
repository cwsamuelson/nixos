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

    # Define which users belong to which host
    nixosConfigurations =
      let
        availableUsers = attrNames user_configs;
        availableHosts = attrNames host_configs;

        hostUsers = {
          wsl = [ "chris" ];
          laptop-ava = [ "chris" ];
          laptop-fw = [ "chris" ];
        };

        # Validate all referenced users and hosts exist
        validateUsers = hostname: usernames:
          let
            invalid = filter (u: !(elem u availableUsers)) usernames;
          in
          if invalid != []
            then throw "Host '${hostname}' references non-existent users: ${toString invalid}"
          else usernames;

        validateHosts =
          let
            referencedHosts = attrNames hostUsers;
            invalid = filter (h: !(elem h availableHosts)) referencedHosts;
          in
          if invalid != []
            then throw "hostUsers references non-existent hosts: ${toString invalid}"
          else hostUsers;

        # Generate configurations for specified host-user pairs
        pairs = flatten (mapAttrsToList (hostname: usernames:
          map (username: {
            name = "${hostname}";
            value = makeSystem hostname username
                      host_configs.${hostname}
                      user_configs.${username};
          }) (validateUsers hostname usernames)
        ) (validateHosts));
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
        config-wsl = makeAssertionCheck "config-wsl" configTests.testWslExists;
        config-laptop-fw = makeAssertionCheck "config-laptop-fw" configTests.testLaptopFwExists;
        config-laptop-ava = makeAssertionCheck "config-laptop-ava" configTests.testLaptopAvaExists;
        config-chris-home = makeAssertionCheck "config-chris-home" configTests.testHomeExists;
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

        # Home Manager activation packages can be safely built
      } // (mapAttrs' (name: config:
        nameValuePair "nixos-config-${name}" config.config.system.build.etc
      ) nixosConfigurations)
      // (mapAttrs' (name: config:
        nameValuePair "home-config-${name}" config.activationPackage
      ) homeConfigurations);
  };
}
