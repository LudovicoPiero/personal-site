{
  description = "example-node-js-flake";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        buildNodeJs = pkgs.callPackage "${nixpkgs}/pkgs/development/web/nodejs/nodejs.nix" {
          python = pkgs.python3;
        };

        nodejs = buildNodeJs {
          enableNpm = true;
          version = "20.4.0";
          sha256 = "sha256-Cb0Lc8UmtjwCnV3f2IXRCWLnrYfJdblFg8H4zpDuU0g=";
        };
      in rec {
        flakedPkgs = pkgs;

        # enables use of `nix shell`
        devShell = pkgs.mkShell {
          # add things you want in your shell here
          buildInputs = with pkgs; [
            nodejs
          ];
        };
      }
    );

  # nixConfig = {
  #   extra-substituters = [
  #     "https://cache.garnix.io"
  #   ];
  #   extra-trusted-public-keys = [
  #     "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
  #   ];
  # };
}
