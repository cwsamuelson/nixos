{ ... }: {
  systemd.coredump.enable = false;

  # changed for AFL fuzzer
  powerManagement.cpuFreqGovernor = "performance";
}
