({ lib, ... }: {
  options = {
    meta.doc = lib.mkOption {
      type = lib.types.oneOf [ lib.types.path lib.types.string ];
      internal = true;
      example = "./meta.chapter.md";
      description = ''
        Documentation prologue for the set of options of each module.  This
        option should be defined at most once per module.
      '';
    };
  };
})
