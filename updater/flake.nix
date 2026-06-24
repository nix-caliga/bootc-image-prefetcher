{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      inherit (pkgs) lib;

      imageSpecs = import ./images.nix;

      registriesConf = pkgs.writeText "registries.conf" "unqualified-search-registries = []\n";

      imagesToPrefetch = lib.concatLists (
        lib.mapAttrsToList (
          name: img:
          map (tag: {
            inherit name tag;
            inherit (img) imageName;
          }) img.tags
        ) imageSpecs
      );

      prefetchRun = lib.concatMapStringsSep "\n" (
        img:
        "prefetch ${
          lib.escapeShellArgs [
            img.name
            img.tag
            img.imageName
          ]
        }"
      ) imagesToPrefetch;

      validPins = lib.concatMapStringsSep "\n" (img: "pins/${img.name}/${img.tag}.nix") imagesToPrefetch;
    in
    {
      packages.x86_64-linux.update = pkgs.writeShellApplication {
        name = "updater";
        runtimeInputs = [
          pkgs.nix-prefetch-docker
          pkgs.nix
          pkgs.coreutils
        ];
        text = ''
          export CONTAINERS_REGISTRIES_CONF=${registriesConf}
          failed=()

          prefetch() {
            local name=$1 tag=$2 image=$3 pin
            echo "prefetching $name:$tag"
            if pin=$(nix-prefetch-docker --quiet --arch amd64 --os linux \
                       --image-name "$image" --image-tag "$tag"); then
              mkdir -p "pins/$name"
              printf '%s\n' "$pin" > "pins/$name/$tag.nix"
            else
              failed+=("$name:$tag")
            fi
            if [ -n "''${CI:-}" ]; then nix-collect-garbage -d >/dev/null 2>&1 || true; fi
          }

          ${prefetchRun}


          # remove no longer tracked pins
          valid_pins="${validPins}"

          if [ -d pins ]; then
            while IFS= read -r pin; do
              if ! printf '%s\n' "$valid_pins" | grep -qxF "$pin"; then
                echo "removing stale pin: $pin"
                rm "$pin"
              fi
            done < <(find pins -name '*.nix')
            find pins -type d -empty -delete
          fi

          # fail workflow if any pin failed to update, but only after committing the successful updates
          if [ "''${#failed[@]}" -gt 0 ]; then
            echo "::error::pins not refreshed this run: ''${failed[*]}"
            exit 1
          fi
        '';
      };
    };
}
