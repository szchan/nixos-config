final: prev: {
  mihomo = prev.mihomo.overrideAttrs (old: rec {
    version = "1.19.33";
    src = prev.fetchFromGitHub {
      owner = "MetaCubeX";
      repo = "mihomo";
      rev = "v${version}";
      hash = "sha256-O2OJ0WFt0T32yOIT1El+ACJWVm2oAJOjU1JTDXb2IEo=";
    };
    vendorHash = "sha256-wPkqyp2iuA762qID2FK3xWOMU5ZNxAle8saCmZzpeSI=";
  });
}
