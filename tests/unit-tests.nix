{ lib }:

with lib;

# Unit tests for flake helper functions
runTests {
  # Test username extraction from full name
  testUsernameExtraction = {
    expr = toLower (head (splitString " " "Chris Samuelson"));
    expected = "chris";
  };

  testUsernameExtractionSingleName = {
    expr = toLower (head (splitString " " "Admin"));
    expected = "admin";
  };

  testUsernameExtractionMultipleSpaces = {
    expr = toLower (head (splitString " " "John Paul Jones"));
    expected = "john";
  };

  # Test attribute merging
  testUserConfigMerge = {
    expr = let
      user_config = {
        name = "Test User";
        email = "test@example.com";
        groups = ["wheel"];
      };
      user = {
        inherit (user_config) name email groups;
        username = toLower (head (splitString " " user_config.name));
      };
    in user.username;
    expected = "test";
  };

  # Test that hostname-username pairs are generated correctly
  testPairGeneration = {
    expr = let
      hosts = { host1 = {}; host2 = {}; };
      users = { user1 = {}; user2 = {}; };
      pairs = flatten (mapAttrsToList (hostname: host_config:
        mapAttrsToList (username: user_config: {
          name = "${hostname}-${username}";
        }) users
      ) hosts);
    in map (p: p.name) pairs;
    expected = [ "host1-user1" "host1-user2" "host2-user1" "host2-user2" ];
  };

  # Test list flattening works as expected
  testFlattenList = {
    expr = flatten [ [ 1 2 ] [ 3 4 ] ];
    expected = [ 1 2 3 4 ];
  };

  # Test listToAttrs conversion
  testListToAttrs = {
    expr = listToAttrs [
      { name = "foo"; value = 42; }
      { name = "bar"; value = 24; }
    ];
    expected = { foo = 42; bar = 24; };
  };
}
