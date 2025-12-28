# An example of building and Android app with Nix

To generate a dependency tree, run `nix develop -c resolve-gradle-deps`.

To generate Nix lockfiles, run `nix develop -c regen-lock`.

To build the APK, run `nix build`.

To do these three steps at once, run `nix develop -c build-apk`.

# Based on

* https://github.com/nix-community/nix-on-droid-app/pull/6 by phanirithvij
* https://github.com/andymuncey/kotlin-android-hello-world by andymuncey,
  itself based on the tutorial at
  http://tutorials.tinyappco.com/Kotlin/AndroidHelloWorld.
