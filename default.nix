let pkgs = import <nixpkgs> {};
in pkgs.callPackage (
    { stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses
    , libXft, conf ? null, patches ? [], extraLibs ? []}:

    with stdenv.lib;

    stdenv.mkDerivation rec {
    pname = "st";
    version = "0.8.4";

    src = fetchurl {
        url = "https://github.com/llathasa-veleth/${pname}/archive/${version}.tar.gz";
        sha256 = "0zqbd8rdpq0w0gip3cvrylzkmi3017lcyqgmnbwzisk4x733zn7q";
    };

    inherit patches;

    configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
    postPatch = optionalString (conf!=null) "cp ${configFile} config.def.h";

    nativeBuildInputs = [ pkgconfig ncurses ];
    buildInputs = [ libX11 libXft ] ++ extraLibs;

    installPhase = ''
        TERMINFO=$out/share/terminfo make install PREFIX=$out
    '';

    meta = {
        homepage = "https://st.suckless.org/";
        description = "Simple Terminal for X from Suckless.org Community";
        license = licenses.mit;
    };
    }
) {}
