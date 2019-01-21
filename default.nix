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

    dmenu2 = previous.dmenu2.overrideAttrs (super: {
      buildInputs = super.buildInputs ++ [ makeWrapper ];
      postFixup = ''
        wrapProgram $out/bin/dmenu_run --run "source ${./dmenu2-flags.sh}"
      '';
    });
  };
}
