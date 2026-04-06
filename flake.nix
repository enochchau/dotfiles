{
  description = "Dotfiles runner for macOS and NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f:
        lib.genAttrs systems (system:
          f {
            inherit system;
            pkgs = import nixpkgs { inherit system; };
          });
    in
    {
      devShells = forAllSystems ({ pkgs, ... }:
        let
          runtimeLibPath = lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
          ];
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              gnumake
              python313
              uv
            ];

            shellHook = lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
              export LD_LIBRARY_PATH="${runtimeLibPath}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
            '';
          };
        });

      apps = forAllSystems ({ pkgs, ... }:
        let
          runtimeLibPath = lib.makeLibraryPath [
            pkgs.stdenv.cc.cc.lib
          ];
          linuxRuntimeSetup = lib.optionalString pkgs.stdenv.hostPlatform.isLinux ''
            export LD_LIBRARY_PATH="${runtimeLibPath}${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
          '';
        in
        {
          run = {
            type = "app";
            program = toString (pkgs.writeShellScript "dotfiles-run" ''
              ${linuxRuntimeSetup}
              exec ${pkgs.gnumake}/bin/make run "$@"
            '');
          };
          default = self.apps.${pkgs.system}.run;
        });
    };
}
