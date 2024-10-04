{
  description = "Argument_search project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Define the C++ project
        cppProject = pkgs.clangStdenv.mkDerivation {
          name = "Argument_search";
          src = ./.;

          nativeBuildInputs = with pkgs; [ gnumake ];

          buildInputs = with pkgs; [ ];

          buildPhase = ''
            make -j $($NIX_BUILD_CORES)
          '';

          installPhase = ''
            mkdir -p $out/bin
            cp build/Argument_search $out/bin/
          '';
        };

      in {
        packages = {
          argument_search = cppProject;
          default = cppProject;
        };

        apps = {
          argument_search = flake-utils.lib.mkApp { drv = cppProject; };
          default = flake-utils.lib.mkApp { drv = cppProject; };
        };

        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [ ccache gnumake git git-filter-repo ];

          buildInputs = with pkgs; [ clang libcxx ];

          shellHook = ''
            export CC=clang
            export CXX=clang++
            export CXXFLAGS="''${CXXFLAGS:-}"

            export CCACHE_DIR=$HOME/.ccache
            export PATH="$HOME/.ccache/bin:$PATH"

            alias c=clear

            echo "C++ Development Environment"
            echo "======================================"
            echo "$(clang --version | head -n 1)"
            echo "$(make --version | head -n 1)"
            echo ""
            echo "Build the project:  nix build .#argument_search"
            echo "Run the project:    nix run   .#argument_search"
            echo ""
            echo "Happy coding!"
          '';
        };
      }
    );
}
