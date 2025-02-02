{ pkgs
, config
, lib
, inputs
, ...
}: {
  system = {
    defaults = {
      # Restart for changes to take an effect.
      NSGlobalDomain."com.apple.trackpad.scaling" = 3.0;
      NSGlobalDomain.KeyRepeat = 2;
      NSGlobalDomain.InitialKeyRepeat = 15;

      trackpad.Clicking = true;
      trackpad.TrackpadThreeFingerDrag = true;
    };
  };
}
