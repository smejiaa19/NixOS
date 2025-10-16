{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell{
	buildInputs = [
		pkgs.python312
		pkgs.python312Packages.pip
		pkgs.python312Packages.virtualenv
	];

	shellHook = ''
		echo " Hola chaval estamos usando la piton"
		python3 --version
		'';
}
