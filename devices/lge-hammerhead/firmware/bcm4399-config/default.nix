{ lib, runCommand, fetchurl }:

let
  pmaPortsRev = "9ae9a7eb2c70d6b23e52826f3c63c84117680003";
  config = fetchurl {
    url = "https://gitlab.com/postmarketOS/pmaports/-/raw/${pmaPortsRev}/device/testing/device-lg-hammerhead/brcmfmac4339-sdio.txt";
    hash = "sha256-Tb90IYuME5WmqVC5f3GSwDS+kMTMqM9DjzhBU0yAkQo=";
  };
in runCommand "bcm4399-firmware-config" {
  meta = with lib; {
    description = "Wi-Fi driver configuration for the Nexus 5";
    homepage = "https://gitlab.com/postmarketOS/pmaports";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ metadark ];
  };
} ''
  mkdir -p "$out/lib/firmware/brcm"
  cp ${config} "$out/lib/firmware/brcm/brcmfmac4339-sdio.txt"
''
