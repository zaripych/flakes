{...}: {
  programs.bash = {
    completion.enable = true;

    interactiveShellInit = ''
      # Don't store duplicate commands in history
      export HISTCONTROL=ignoredups:erasedups
      export HISTSIZE=10000
      export HISTFILESIZE=20000

      # Append to history file, don't overwrite it
      shopt -s histappend
    '';
  };
}
