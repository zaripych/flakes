{ useFeatureAt, ... }: {

  imports = [
    (useFeatureAt ../patch-inputs/module.nix)
  ];

  config = {
    inputsToPatch.home-manager = [
      {
        url = "https://patch-diff.githubusercontent.com/raw/nix-community/home-manager/pull/5640.patch";
        hash = "sha256-AxGs42jwyhPIF2HG30whKF12MlRANOIcqttKbBA38O8=";
      }
    ];
  };
}
