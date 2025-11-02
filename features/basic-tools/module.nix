{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    fd
    ripgrep
    jq
    _1password-cli
  ];
}
