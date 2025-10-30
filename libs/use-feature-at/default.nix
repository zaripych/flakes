{parentPath ? "./"}:
# Prints the path of a module being imported, handy for debugging the modules tree
path: let
  fullPath = toString path;
  # Match the pattern: /nix/store/<hash>-source/
  relativePath = let
    parts = builtins.match "(/nix/store/[^/]+-source/)(.+)" fullPath;
  in
    if parts != null
    then parentPath + builtins.elemAt parts 1
    else fullPath;
in
  toString
  (
    builtins.trace
    ("Using " + relativePath)
    path
  )
