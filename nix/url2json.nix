# This script url2json.sh is the heart behind gradle dependency lock generation
{
  stdenv, fetchurl, writeShellApplication, coreutils, bash, gnugrep, curl, nix, jq, htmlq
}:
let
  url2json-uncached = stdenv.mkDerivation {
    name = "url2json-uncached";
    phases = [ "buildPhase" ];
    src = fetchurl {
      url = "https://github.com/status-im/status-mobile/raw/2df7a7cf6d46c8d1add73b8965ce8b04e6f7d014/nix/deps/gradle/url2json.sh";
      hash = "sha256-McEyQPvofpMYv7mvX/7m/eRNYxJOUkm98foSYmYOyE4=";
      executable = true;
    };
    buildPhase = ''
      mkdir -p $out/bin; cd $out/bin
      cp $src url2json.sh
      chmod +w url2json.sh
      patch -p1 < ${./url2json-fix-printing.patch}
      #sed -i 's|2>/dev/null||' url2json.sh
      chmod -w url2json.sh
      mv url2json.sh url2json
    '';
    meta.mainProgram = "url2json";
  };
  url2json-cached = writeShellApplication {
    name = "url2json";
    runtimeInputs = [ coreutils bash gnugrep curl nix jq htmlq ];
    inheritPath = false;
    text = ''
      mkdir -p .cache/url2json/
      in_hash=$(sha256sum <<<"$1" | cut -f1 -d' ')
      in_hash_file=".cache/url2json/$in_hash"
      if [[ -e "$in_hash_file" ]]; then
          cat "$in_hash_file"
      else
          res=$(${url2json-uncached}/bin/url2json "$1")
          ret=$?
          if [[ "$ret" == 0 ]]; then
              tee "$in_hash_file.tmp" <<<"$res"
              mv "$in_hash_file.tmp" "$in_hash_file"
          fi
          exit "$ret"
      fi
    '';
  };
in
  url2json-cached
