{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.fuzzing;

  chosenEngine = with pkgs; {
    "aflplusplus" = aflplusplus;
    "honggfuzz" = honggfuzz;
    "libfuzzer" = lubfuzzer;
  }.${cfg.engine};
in
{
  options.fuzzing = {
    # fuzzing.enable = true/false;
    enable = mkEnableOption "Fuzzing support";

    # fuzzing.extraPackages = [ pkgs.cargo-fuzz ];
    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
      description = "Extra packages to install with the fuzzing.";
    };

    options.fuzzing.engine = mkOption {
      type = types.enum [ 
        "aflplusplus"
        "honggfuzz"
        "libfuzzer"
      ];

      default = "aflplusplus";
      description = "Select which fuzzing engine to use.";
    };
  };

  config = mkIf cfg.enable {
    systemd.coredump.enable = false;

    powerManagement.cpuFreqGovernor = "performance";

    #boot.kernel.sysctl = mkMerge [
    #  (mkIf (cfg.engine == "aflplusplus") {
    #    "kernel.core_pattern" =  "|/usr/lib/systemd/systemd-coredump %p %u %g %s %t %e";
    #  })
    #  (mkIf (cfg.engine == "honggfuzz") {
    #    "kernel.unpriveleged_userns_clone" = 1;
    #  })
    #];

    #environment.systemPackages = with pkgs; [ aflplusplus ];

    #security.pam.loginLimits = [
    #  { domain = "*"; type = "soft"; item = "core"; value = "unlimited"; }
    #  { domain = "*"; type = "hard"; item = "core"; value = "unlimited"; }
    #];

    ## Enable required kernel options or services as needed
    #systemd.tmpfiles.rules = [
    #  "d /var/lib/fuzzing 0755 root root"
    #];

    environment.systemPackages = cfg.extraPackages ++ [ chosenEngine ];
  };
}
