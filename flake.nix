{
  description = "Cubyz FHS development shell";

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
          default =
            let
              fhsEnv = pkgs.buildFHSEnv {
                name = "cubyz-shell";
                targetPkgs = p: [
                  p.libx11
                  p.libxcursor
                  p.vulkan-loader
                  p.vulkan-validation-layers
                  p.libGL
                ];
              };
            in
            fhsEnv.env;
        }
      );
    };
}
