with import <nixpkgs> {};
let
  pythonEnv = python3.withPackages(ps: [ps.tkinter]);
  matplotlib = python35Packages.matplotlib.override {
    enableTk = true;
  };
in
{
  graphEnv = stdenv.mkDerivation {
    name = "graphEnv";
    buildInputs = [ stdenv pythonEnv python35Packages.numpy matplotlib ];
  };
}
