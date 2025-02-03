{ useFeatureAt, ... }: {

  imports = [
    (useFeatureAt ../patch-inputs/module.nix)
  ];

  config = {
    inputsToPatch.home-manager = [
      {
        url = "https://patch-diff.githubusercontent.com/raw/nix-community/home-manager/pull/5640.patch";
        hash = "sha256-ro0al4bywDtx+k+6WPd21f6n3aOz1o9PaRr+/iO4xBs=";
      }
    ];
  };
}
