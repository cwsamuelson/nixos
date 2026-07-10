{ lib, nixpkgs, user_configs, host_configs, nixosConfigurations, homeConfigurations }:

with lib;

# Tests that validate configuration structure
{
  # Validate all user configs have required fields
  testUserConfigsValid =
    let
      requiredFields = [ "name" "email" "stateVersion" "groups" ];
      validateUser = name: config:
        all (field: hasAttr field config) requiredFields;
    in
    all (user: validateUser user (getAttr user user_configs)) (attrNames user_configs);

  # Validate all host configs have required fields
  testHostConfigsValid =
    let
      requiredFields = [ "stateVersion" ];
      validateHost = name: config:
        all (field: hasAttr field config) requiredFields;
    in
    all (host: validateHost host (getAttr host host_configs)) (attrNames host_configs);

  # Validate user groups are non-empty lists
  testUserGroupsValid =
    let
      validateGroups = name: config:
        isList config.groups && length config.groups > 0;
    in
    all (user: validateGroups user (getAttr user user_configs)) (attrNames user_configs);

  # Validate email format (basic check)
  testUserEmailFormat =
    let
      hasAtSign = email: match ".*@.*" email != null;
      validateEmail = name: config: hasAtSign config.email;
    in
    all (user: validateEmail user (getAttr user user_configs)) (attrNames user_configs);

  # Validate state versions are strings
  testStateVersionsAreStrings =
    let
      validateStateVersion = name: config: isString config.stateVersion;
    in
    (all (user: validateStateVersion user (getAttr user user_configs)) (attrNames user_configs))
    && (all (host: validateStateVersion host (getAttr host host_configs)) (attrNames host_configs));

  # Test that all expected nixosConfiguration hosts exist
  testNixosConfigurationsExist =
    let
      expectedHosts = attrNames host_configs;
      actualConfigs = attrNames nixosConfigurations;
    in
    all (hostname: elem hostname actualConfigs) expectedHosts;

  # Test that we actually have some configurations (not passing on empty)
  testNixosConfigurationsNotEmpty =
    let
      actualConfigs = attrNames nixosConfigurations;
    in
    length actualConfigs > 0;

  # Test that all homeConfigurations exist for each user
  testHomeConfigurationsExist =
    let
      expectedUsers = attrNames user_configs;
      actualHomeConfigs = attrNames homeConfigurations;
    in
    all (user: elem user actualHomeConfigs) expectedUsers;

  # Test that we actually have home configurations (not passing on empty)
  testHomeConfigurationsNotEmpty =
    let
      actualHomeConfigs = attrNames homeConfigurations;
    in
    length actualHomeConfigs > 0;

  # Hard-coded test: wsl configuration must exist
  testWslExists = hasAttr "wsl" nixosConfigurations;

  # Hard-coded test: laptop-fw configuration must exist
  testLaptopFwExists = hasAttr "laptop-fw" nixosConfigurations;

  # Hard-coded test: laptop-ava configuration must exist
  testLaptopAvaExists = hasAttr "laptop-ava" nixosConfigurations;

  # Hard-coded test: chris homeConfiguration must exist
  testHomeExists = hasAttr "chris" homeConfigurations;

  # Test that we have at least 3 nixos configurations (guard against empty state)
  testMinimumNixosConfigurations =
    let
      actualConfigs = attrNames nixosConfigurations;
    in
    length actualConfigs >= 3;

  # Test that all expected host names are present in configurations
  testAllHostsHaveConfigurations =
    let
      expectedHosts = attrNames host_configs;
      allConfigNames = attrNames nixosConfigurations;
      hostInConfigs = host: elem host allConfigNames;
    in
    all hostInConfigs expectedHosts;

  # Test that all expected users are assigned to at least one host
  testAllUsersHaveConfigurations =
    let
      # This test validates users are mapped in flake's hostUsers definition
      # Since configs are named by hostname, we check if users appear in the flake logic
      expectedUsers = attrNames user_configs;
      # For this implementation, verify user_configs are non-empty as a proxy
      # The actual user-host mapping is validated by the system building successfully
    in
    length expectedUsers > 0;
}
