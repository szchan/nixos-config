# oh-my-pi。官方 flake 提供 programs.omp。
{ inputs, ... }:

{
  imports = [
    inputs.omp.homeManagerModules.default
  ];

  programs.omp.enable = true;
}
