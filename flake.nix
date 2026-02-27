{
  description = "Cubyz development shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    {
      nixpkgs,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      systems = lib.systems.flakeExposed;

      forAllSystems =
        f:
        lib.genAttrs systems (
          system:
          f {
            inherit system;
            pkgs = nixpkgs.legacyPackages.${system};
          }
        );
    in
    {
      devShells = forAllSystems (
        { system, pkgs, ... }:
        {
          default = pkgs.mkShell {
            shellHook = ''
              export LD_LIBRARY_PATH="${
                lib.makeLibraryPath [
                  pkgs.libx11
                  pkgs.libxcursor
                  pkgs.vulkan-loader
                  pkgs.vulkan-validation-layers
                  pkgs.libGL
                ]
              }:$LD_LIBRARY_PATH"
            '';
          };
        }
      );
    };
}
