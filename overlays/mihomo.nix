final: prev: {
  clash-verge-rev = prev.clash-verge-rev.override {
    mihomo = prev.mihomo.overrideAttrs (old: rec {
      version = "1.19.33";
      src = prev.fetchFromGitHub {
        owner = "MetaCubeX";
        repo = "mihomo";
        rev = "v${version}";
        hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
      };
    });
  };
}
