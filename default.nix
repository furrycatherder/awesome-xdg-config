final: previous:
with final; {
  arch-xdg-menu = callPackage ./arch-xdg-menu.nix { };

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
      rev = "9a764c29fd8f493555f73cedb696a89191f702cb";
      sha256 = "0xvrhr1asymhjkm7wgv6jar100apyyii9m4k17i0cv4pa67pjqdc";
    };
  });

  wpgtk = previous.wpgtk.overrideAttrs (super: {
    propagatedBuildInputs = with final.python3Packages; [
      pygobject3
      pillow
      final.pywal
    ];
  });

  dmenu = previous.dmenu.overrideAttrs (super: {
    buildInputs = super.buildInputs ++ [ final.makeWrapper ];
    patches = let
      fetchPatch = path:
        builtins.fetchurl "https://tools.suckless.org/dmenu/patches/${path}";
    in super.patches ++ [
      (fetchPatch "line-height/dmenu-lineheight-4.9.diff")
      (fetchPatch "xyw/dmenu-xyw-4.7.diff")
      ./dmenu-dim-20191228-cbef4ab.diff
      ./dmenu-tabright-20191228-acc1cee.diff
    ];
    postFixup = ''
      geom=(1920 1080)
      width=$((3 * geom[0] / 5))
      height=40
      xpos=$(((geom[0] - width) / 2))
      ypos=$((5 * (geom[1] - height) / 12))

      wrapProgram $out/bin/dmenu_run \
        --add-flags "-x $xpos -y $ypos -w $width -h $height -dim 0.8"
    '';
  });

}
