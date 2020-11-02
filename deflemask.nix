with import <nixpkgs> { system = "i686-linux"; };

stdenv.mkDerivation rec {
  name = "deflemask";
  version = "";

  src = fetchurl {
    url = "https://www.deflemask.com/DefleMask_Linux.tar.gz";
    sha256 = "7c92b81843345d5c4f239d5deebc264f02556a98f7c4272523978bb963a6feee";
  };

  nativeBuildInputs = [
	autoPatchelfHook
  ];

  buildInputs = [
	xorg.libX11
	xorg.libXext
	libGL
	libGLU
	SDL
  	gtk2-x11
  	gobject-introspection
  ];

  dontPatchELF = true;

  unpackPhase = ''
    tar xvf $src
  '';

  installPhase = ''
	install -m755 -D DefleMask $out/DefleMask
	install -m755 -D config.ini $out/config.ini
	install -m755 -D manual.pdf $out/manual.pdf
	for D in */; do
		mkdir $out/$D
		cp -rp $D/* $out/$D
	done 
  '';

  meta = with stdenv.lib; {
    homepage = https://deflemask.com;
    description = "DefleMask Tracker";
    platforms = platforms.linux;
    maintainers = with maintainers; [ Skyliegirl33 ];
  };
}
