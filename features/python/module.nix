{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    python3Packages.uv
  ];

  # Allow uv to install to the home directory
  programs.zsh.shellInit = ''
    export PATH=~/.local/bin:$PATH
  '';
}
