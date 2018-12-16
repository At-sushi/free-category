{}:
with builtins;
let
  rev = "cb95a3c1d1b6cd9da65650be269436cbe9e265fa";
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  config =
    { packageOverrides = super:
      let self = super.pkgs;
          lib = super.haskell.lib;
          overrides = self: super: {
            free-algebras = super.callPackage ./free-algebras.nix {};
          };
      in {
        haskell = super.haskell // {
          packages = super.haskell.packages // {
            ghc862 = super.haskell.packages.ghc862.override {
              overrides = super: self: overrides super self // {
                hoopl_3_10_2_2 = self.callPackage ./hoopl-3.10.2.2.nix {};
              };
            };
            ghc861 = super.haskell.packages.ghc861.override {
              overrides = super: self: overrides super self // {
                hoopl_3_10_2_2 = self.callPackage ./hoopl-3.10.2.2.nix {};
              };
            };
            ghc844 = super.haskell.packages.ghc844.override { inherit overrides; };
            ghc822 = super.haskell.packages.ghc822.override { inherit overrides; };
            ghc802 = super.haskell.packages.ghc802.override {
              overrides = self: super: overrides self super // {
                ansi-terminal = super.callPackage ./ansi-terminal-0.6.3.1.nix {};
                async = super.callPackage ./async-2.1.1.1.nix {};
                lifted-async = super.callPackage ./lifted-async-0.9.3.3.nix {};
                exceptions = super.callPackage ./exceptions-0.8.3.nix {};
                stm = super.callPackage ./stm-2.4.5.1.nix {};
                concurrent-output = super.callPackage ./concurrent-output-1.9.2.nix {};
              };
            };
          };
        };
      };
    };
  nixpkgs = import (fetchTarball { inherit url; }) { inherit config; };
in nixpkgs
