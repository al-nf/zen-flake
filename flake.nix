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
      packages.${system}.zen-browser =
        let
          wrapped = pkgs.appimageTools.wrapType2 {
            pname = "zen-browser";
            inherit version;

            src = pkgs.fetchurl {
              url =
                "https://github.com/zen-browser/desktop/releases/download/${version}/zen-x86_64.AppImage";
              sha256 = "sha256-hBDQW8a1KsFDDT+2QYR27BZclbMXh3Zb92QnmqmuIPA=";
            };

            buildInputs = [ pkgs.xdg_utils ];

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
        in
        pkgs.makeWrapper wrapped {
          name = "zen-browser";
          setEnv = {
            BROWSER = "$out/bin/zen-browser";
          };
        };

      defaultPackage.${system} =
        self.packages.${system}.zen-browser;
    };
}
