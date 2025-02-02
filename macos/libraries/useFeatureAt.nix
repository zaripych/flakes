{}: {
  # Prints the path of a module being imported, handy for debugging the modules tree
  useFeatureAt = path:
    toString
      # (builtins.trace
      # ("Using " + toString path)
      (path)
    # )
  ;
}
