# Testing Your NixOS Flake

## Running Tests

### Run All Tests
```bash
nix flake check
```

### Run Specific Test
```bash
nix build .#checks.x86_64-linux.unit-tests
nix build .#checks.x86_64-linux.config-user-fields
```

### List All Available Checks
```bash
nix flake show --json | jq '.checks."x86_64-linux" | keys'
```

## Test Categories

### 1. Unit Tests (`unit-tests.nix`)
Tests for pure helper functions:
- Username extraction from full names
- List operations (flatten, mapAttrs, etc.)
- Attribute merging

### 2. Configuration Validation Tests (`config-tests.nix`)
Validates your configuration structure:
- Required fields present in user/host configs
- Email format validation
- State version format validation
- User groups are valid lists

**Configuration Existence Tests (Automatic)**:
- All expected nixosConfiguration user×host combinations exist
- All expected homeConfigurations exist for each user
- All hosts have at least one configuration
- All users have at least one configuration
- Configurations are not empty

**Configuration Existence Tests (Hard-coded)**:
- `wsl-chris` exists
- `laptop-fw-chris` exists
- `laptop-ava-chris` exists
- `chris` homeConfiguration exists
- At least 3 nixos configurations exist (prevents false positives on empty state)

### 3. Build Checks
Automatically generated checks that verify configurations can build:

**NixOS Configurations**:
- `nixos-config-wsl-chris`
- `nixos-config-laptop-ava-chris`
- `nixos-config-laptop-fw-chris`

**Home Manager Configurations**:
- `home-config-chris`

### 4. Property Tests (`property-tests.nix`)
Tests that verify critical configuration properties are set correctly:

**System Properties**:
- Firewall enabled on all systems
- NetworkManager enabled
- Nix flakes experimental features enabled
- Pipewire enabled (pulseaudio disabled)
- Laptop systems have xserver enabled
- WSL systems don't have desktop manager configured
- Dvorak keyboard layout (dvp variant) on systems with xserver

**Home Manager Properties**:
- Neovim enabled and set as default editor
- Bash enabled for chris
- Git enabled for all users
- Critical programs enabled (bat, btop, jq, ripgrep, difftastic)
- Essential CLI tools available (curl, fd, yq)
- Firefox available for chris
- Home-manager itself enabled

## Adding New Tests

### Add Unit Test
Edit `tests/unit-tests.nix`:
```nix
testNewFunction = {
  expr = yourFunction input;
  expected = expectedOutput;
};
```

### Add Config Validation
Edit `tests/config-tests.nix`:
```nix
testNewValidation =
  let
    validate = name: config: # your validation logic
  in
  all (item: validate item (getAttr item yourConfigs)) (attrNames yourConfigs);
```

### Add Property Test
Edit `tests/property-tests.nix`:
```nix
testPropertyName =
  let
    allConfigs = attrNames nixosConfigurations; # or homeConfigurations
    checkProperty = name:
      nixosConfigurations.${name}.config.some.property.value;
  in
  all checkProperty allConfigs;
```

Then add to `flake.nix` checks:
```nix
prop-my-test = makeAssertionCheck "prop-my-test" propertyTests.testPropertyName;
```

## CI Integration

Add to your CI pipeline:
```yaml
- name: Run Nix tests
  run: nix flake check --all-systems
```

## Test Philosophy

- **Unit tests**: Fast, test pure functions in isolation
- **Config tests**: Validate data structure invariants
- **Build checks**: Ensure configurations are evaluable (slower, but comprehensive)
