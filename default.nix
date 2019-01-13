{
  overlays = final: previous: with final; {
    arch-xdg-menu = callPackage ./arch-xdg-menu.nix {};

    dmenu2 = previous.dmenu2.overrideAttrs (super: {
      buildInputs = super.buildInputs ++ [ makeWrapper ];
      postFixup = ''
        wrapProgram $out/bin/dmenu_run --run "source ${./dmenu2-flags.sh}"
      '';
    });
  };
}
