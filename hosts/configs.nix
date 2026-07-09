let
  stateVersion = "26.11";
in
{
  wsl = {
    inherit stateVersion;
  };

  laptop-ava = {
    inherit stateVersion;
  };

  laptop-fw = {
    inherit stateVersion;
  };
}