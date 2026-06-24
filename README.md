# bootc-image-prefetcher

Nightly refreshed `dockerTools.pullImage` pins for bootc images.

Edit /updater/images.nix to adjust which images/tags are pinned.

Example: feed a pin to [nix-caliga](https://github.com/nix-caliga/nix-caliga) as its base image.
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-caliga = {
      url = "github:nix-caliga/nix-caliga";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bootc-image-prefetcher.url = "github:nix-caliga/bootc-image-prefetcher";
  };

  outputs =
    { nixpkgs, nix-caliga, bootc-image-prefetcher, ... }:
    {
      caligaConfigurations.x86_64-linux.myimage = nix-caliga.lib.makeCaligaConfigurations {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          (
            { pkgs, ... }:
            {
              layeredImage = {
                name = "ghcr.io/your/image";
                tag = "your-tag";
                # pick the image you want
                fromImage = pkgs.dockerTools.pullImage bootc-image-prefetcher.pins.fedora-base-atomic."43";
              };

              caliga.os = "fedora";
              caliga.core.enable = true;
            }
          )
        ];
      };
    };
}
```
