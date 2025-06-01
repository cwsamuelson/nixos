{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.fuzzer;
in
{
  options.fuzzer = {
    enable = mkEnableOption "Fuzzer support";
  };

  config = mkIf cfg.enable {
    # Example config that gets enabled
    environment.systemPackages = with pkgs; [ aflplusplus ];

    boot.kernel.sysctl."kernel.core_pattern" = "|/usr/lib/systemd/systemd-coredump %p %u %g %s %t %e";

    security.pam.loginLimits = [
      { domain = "*"; type = "soft"; item = "core"; value = "unlimited"; }
      { domain = "*"; type = "hard"; item = "core"; value = "unlimited"; }
    ];

    # Enable required kernel options or services as needed
    systemd.tmpfiles.rules = [
      "d /var/lib/fuzzing 0755 root root"
    ];
  };
}
