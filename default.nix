{ stdenv, haskellngPackages }:

let
  env = haskellngPackages.ghcWithPackages (p: with p; [
    happy
    #BROKEN ghc-mod
    hlint
    hoogle
    structured-haskell-mode
    hasktags
    present
    stylish-haskell

    random
    split
  ]);
in
  stdenv.mkDerivation {
    name        = "fractal-trees";
    buildInputs = [env];
    shellHook   = ''
      export NIX_GHC="${env}/bin/ghc"
      export NIX_GHCPKG="${env}/bin/ghc-pkg"
      export NIX_GHC_DOCDIR="${env}/share/doc/ghc/html"
      export NIX_GHC_LIBDIR=$( $NIX_GHC --print-libdir )
    '';
  }
