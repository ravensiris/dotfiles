{ config, lib, pkgs, system, stdenv, ... }:

(pkgs.writeShellScriptBin "emmet-ls" "${pkgs.nodejs}/bin/npx --yes emmet-ls $*")
