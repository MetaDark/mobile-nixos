# Source: https://gitlab.com/postmarketOS/pmaports/-/blob/9ae9a7eb2c70d6b23e52826f3c63c84117680003/main/linux-postmarketos-qcom-msm8974
{ lib
, mobile-nixos
, fetchFromGitLab
, ...
}:

(mobile-nixos.kernel-builder rec {
  version = "5.9.13";
  modDirVersion = "${version}-postmarketos-qcom-msm8974";
  configfile = ./config.armv7l;

  src = fetchFromGitLab {
    owner = "postmarketOS";
    repo = "linux-postmarketos";
    rev = "ad989a3e7324563b3a85e521e052fec2c6b56752"; # qcom-msm8974-5.9.y
    hash = "sha256-amPX1+cihLSf8PEnMhQmKjPwMTmjDgYrIUPjjSGpn44=";
  };

  isModular = true;

  meta = with lib; {
    description = "Kernel close to mainline with extra patches for Qualcomm MSM8974 devices";
    homepage = "https://gitlab.com/postmarketOS/pmaports";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
  };
}).overrideAttrs (attrs: {
  # Strip out debug symbols that break modules closure generation
  dontStrip = false;
})
