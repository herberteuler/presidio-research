{ pkgs ? import <nixpkgs> {} }:

let fhs = pkgs.buildFHSUserEnvBubblewrap {

      name = "presidio-research";

      targetPkgs = pkgs: with pkgs; [
        bash-completion micromamba openssh pre-commit util-linux
      ];
    };

in fhs.env
