{
  description = "Golem Kubernetes Cluster";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    talhelper.url = "github:budimanjojo/talhelper";
  };

  outputs =
    {
      self,
      talhelper,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            talhelper.overlays.default
          ];
          config.allowUnfree = true;
        };
      in
      with pkgs;
      {
        devShell = mkShell {
          # Packages required for development.
          buildInputs = [
            pkgs.talosctl
            pkgs.sops
            pkgs.fluxcd
            pkgs.kubernetes-helm
            pkgs.helm-ls
            pkgs.kustomize
            pkgs.kubeconform
            pkgs.terraform-ls
            pkgs.terraform
            pkgs.opentofu
            pkgs.cilium-cli
          ];
        };
      }
    );

}
