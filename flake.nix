{
  description = "Nightly prefetched dockerTools.pullImage pins for bootc images";

  outputs =
    { }:
    let
      images = import ./updater/images.nix;
      pinPath = name: tag: ./pins + "/${name}/${tag}.nix";
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
      pins = builtins.mapAttrs (
        name: img:
        genAttrs (builtins.filter (tag: builtins.pathExists (pinPath name tag)) img.tags) (
          tag: import (pinPath name tag)
        )
      ) images;
    };
}
