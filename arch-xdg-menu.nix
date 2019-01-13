{ stdenv, lib, fetchurl, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "arch-xdg-menu";
  version = "0.7.6.3";

  buildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ perl perlPackages.XMLParser ];

  src = fetchurl {
    url = "https://arch.p5n.pp.ru/~sergej/dl/2018/arch-xdg-menu-${version}.tar.gz";
    sha256 = "050r6q7f95sdk7xjxw8azqmhcnmpfj91szi4mkq7pnl2x2z6i5mr";
  };

  sourceRoot = ".";

  installPhase = ''
    install -D -m 0755 xdg_menu $out/bin/xdg_menu
  '';

  postFixup = ''
    wrapProgram $out/bin/xdg_menu \
      --prefix PERL5LIB : ${lib.makePerlPath [ perlPackages.XMLParser ]}
  '';
}
