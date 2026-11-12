{
  description = "Nightly prefetched dockerTools.pullImage pins for bootc images";

  outputs =
    { self, ... }:
    let
      images = import ./updater/images.nix;
      pinPath = name: prefix: tag: ./pins + "/${name}/${prefix}${tag}.nix";
      pinsFor =
        name: prefix: tags:
        genAttrs (builtins.filter (tag: builtins.pathExists (pinPath name prefix tag)) tags) (
          tag: import (pinPath name prefix tag)
        );
      genAttrs =
        names: f:
        builtins.listToAttrs (
          map (name: {
            inherit name;
            value = f name;
          }) names
        );
    in
    {
      # pins.<name>.<tag> = the raw nix-prefetch-docker attrset for that image.
      # pins.<name>.mirror.<tag> = the same image, pulled from this repo's mirror.
      pins = builtins.mapAttrs (
        name: img:
        pinsFor name "" (img.tags ++ img.mirror or [ ])
        // {
          mirror = pinsFor name "mirror." (img.mirror or [ ]);
        }
      ) images;
    };
}
