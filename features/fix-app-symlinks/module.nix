{inputs, ...}: {
  imports = [
    # See https://github.com/hraban/mac-app-util
    inputs.mac-app-utils.darwinModules.default
  ];
}
