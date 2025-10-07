{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
	buildInputs = [
		# pkgs.openjdk21
		pkgs.openjdk17
		pkgs.maven
		pkgs.gradle
	];

	shellHook = ''
		echo "Ola estamos usando javita"
		java --version
		'';
}
