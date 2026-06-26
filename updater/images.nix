{
  fedora-bootc = {
    imageName = "quay.io/fedora/fedora-bootc";
    tags = [
      "44"
      "45"
    ];
  };
  fedora-base-atomic = {
    imageName = "quay.io/fedora-ostree-desktops/base-atomic";
    tags = [
      "44"
    ];
  };
  fedora-kinoite = {
    imageName = "quay.io/fedora-ostree-desktops/kinoite";
    tags = [
      "44"
    ];
  };
  fedora-silverblue = {
    imageName = "quay.io/fedora-ostree-desktops/silverblue";
    tags = [
      "44"
    ];
  };

  # these take so long to fetch

  # ublue-aurora = {
  #   imageName = "ghcr.io/ublue-os/aurora";
  #   tags = [
  #     "stable"
  #     "stable-daily"
  #     "latest"
  #   ];
  # };
  # ublue-base-main = {
  #   imageName = "ghcr.io/ublue-os/base-main";
  #   tags = [
  #     "latest"
  #     "44"
  #   ];
  # };
  # ublue-bazzite = {
  #   imageName = "ghcr.io/ublue-os/bazzite";
  #   tags = [
  #     "stable"
  #     "stable-43"
  #     "latest"
  #   ];
  # };
  # ublue-bluefin = {
  #   imageName = "ghcr.io/ublue-os/bluefin";
  #   tags = [
  #     "stable-daily"
  #     "latest"
  #     "lts"
  #   ];
  # };
  # ublue-kinoite-main = {
  #   imageName = "ghcr.io/ublue-os/kinoite-main";
  #   tags = [
  #     "latest"
  #     "44"
  #   ];
  # };
  # ublue-silverblue-main = {
  #   imageName = "ghcr.io/ublue-os/silverblue-main";
  #   tags = [
  #     "latest"
  #     "44"
  #   ];
  # };
  ublue-ucore = {
    imageName = "ghcr.io/ublue-os/ucore";
    tags = [
      "stable"
      # "latest"
    ];
  };

  # ublue-bluefin-dakota = {
  #   imageName = "ghcr.io/projectbluefin/dakota";
  #   tags = [ "latest" ];
  # };
}
