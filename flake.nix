{
  description = "Zen Browser (AppImage) flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      version = "1.0.0";
    in
    {
      packages.${system}.zen-browser =
        pkgs.appimageTools.wrapType2 {
          pname = "zen-browser";
          inherit version;

          src = pkgs.fetchurl {
            url =
              "https://github.com/zen-browser/zen-browser/releases/download/v${version}/Zen-Browser-x86_64.AppImage";
            sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
          };

          extraInstallCommands = ''
            mkdir -p $out/share/applications
            cat > $out/share/applications/zen-browser.desktop <<EOF
            [Desktop Entry]
            Name=Zen
            Exec=zen-browser
            Icon=zen-browser
            Type=Application
            Categories=Network;WebBrowser;
            EOF
          '';
        };

      defaultPackage.${system} =
        self.packages.${system}.zen-browser;
    };
}

