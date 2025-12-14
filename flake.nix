{
  description = "Zen Browser (AppImage) flake";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      version = "1.17.13b";
    in
    {
      packages = {
        ${system} = {
          zen-browser = pkgs.stdenv.mkDerivation {
            pname = "zen-browser";
            inherit version;

            src = pkgs.fetchurl {
              url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen-x86_64.AppImage";
              sha256 = "sha256-hBDQW8a1KsFDDT+2QYR27BZclbMXh3Zb92QnmqmuIPA=";
            };

            buildInputs = [ pkgs.appimageTools pkgs.xdg_utils pkgs.makeWrapper ];

            installPhase = ''
              mkdir -p $out/bin
              cp $src $out/bin/zen-browser
              wrapProgram $out/bin/zen-browser --set BROWSER $out/bin/zen-browser

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
        };
      };

      defaultPackage.${system} = self.packages.${system}.zen-browser;
    };
}
