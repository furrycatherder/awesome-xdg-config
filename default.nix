{
  overlays = final: previous: with final; {
    arch-xdg-menu = callPackage ./arch-xdg-menu.nix {};

    compton-kawase = previous.compton.overrideAttrs (super: {
      src = previous.fetchFromGitHub {
        owner = "tryone144";
        repo = "compton";
        rev = "241bbc50285e58cbc6a25d45066689eeea913880";
        sha256 = "148s7rkgh5aafzqdvag12fz9nm3fxw2kqwa8vimgq5af0c6ndqh2";
      };

      hardeningDisable = [ "all" ];
    });

    pywal = previous.pywal.overrideAttrs (super: {
      src = previous.fetchFromGitHub {
        owner = "furrycatherder";
        repo = "pywal";
        rev = "4aa28b1bdb641929768748e09ea82e424c168b07";
        sha256 = "01khh1sv4cgws13ykyanshkyjhjx5m6mj6q6rw01d6yqw9nbcpjk";
      };
    });

    wpgtk = previous.wpgtk.overrideAttrs (super: {
      propagatedBuildInputs = with final.python3Packages; [
        pygobject3
        pillow
        final.pywal
      ];
    });

    dmenu2 = previous.dmenu2.overrideAttrs (super: {
      buildInputs = super.buildInputs ++ [ makeWrapper ];
      postFixup = ''
        wrapProgram $out/bin/dmenu_run --run "source ${./dmenu2-flags.sh}"
      '';
    });
  };
}
