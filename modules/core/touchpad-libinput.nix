{...}: {
  services.libinput.enable = true;

  services.libinput.touchpad = {
    tapping = false;
    tapButtons = false;
    naturalScrolling = false;
    disableWhileTyping = true;
    scrollMethod = "twofinger";
    clickMethod = "buttonareas";
    accelProfile = "adaptive";
  };
}
