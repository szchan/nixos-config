final: prev: {
  clash-verge-rev = prev.clash-verge-rev.override {
    mihomo = prev.mihomo.overrideAttrs (old: rec {
      version = "1.19.33";
      src = prev.fetchFromGitHub {
        owner = "MetaCubeX";
        repo = "mihomo";
        rev = "v${version}";
        hash = "sha256-O2OJ0WFt0T32yOIT1El+ACJWVm2oAJOjU1JTDXb2IEo=";
      };
      vendorHash = "";

      preBuild = ''
        export https_proxy = "http://192.168.50.203:8899"
        export http_proxy = "http://192.168.50.203:8899"
        export ALL_PROXY = "http://192.168.50.203:9988"
      '';
    });
  };
}
