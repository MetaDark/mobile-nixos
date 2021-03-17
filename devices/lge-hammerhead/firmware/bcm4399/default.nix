{ lib, fetchurl, runCommand, firmwareLinuxNonfree }:

let
  pname = "bcm4399-firmware";

  # firmwareLinuxNonfree currently violates LICENSE.broadcom_bcm43xx
  # by not including the license with the firmware. Until that's fixed
  # upstream, patch it in manually.
  linuxFirmwareRev = "05789708b79b38eb0f1a20d8449b4eb56d39b39f";
  license = fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/LICENCE.broadcom_bcm43xx?id=${linuxFirmwareRev}";
    hash = "sha256-sWBW/JG4Kg4+jej4bC2smCAaqdw8vTPo048bCH/Oww0=";
  };
in runCommand "${pname}-${firmwareLinuxNonfree.version}" {
  meta = with lib; {
    inherit (firmwareLinuxNonfree.meta) homepage license;
    description = "Wi-Fi drivers for the Nexus 5";
    maintainers = with maintainers; [ metadark ];
  };
} ''
  mkdir -p "$out/lib/firmware/brcm" "$out/share/licenses/${pname}"

  cd "$out/lib/firmware/brcm"
  cp ${firmwareLinuxNonfree}/lib/firmware/brcm/bcm43xx-0.fw .
  cp ${firmwareLinuxNonfree}/lib/firmware/brcm/bcm43xx_hdr-0.fw .
  cp ${firmwareLinuxNonfree}/lib/firmware/brcm/brcmfmac4339-sdio.bin .

  cd "$out/share/licenses/${pname}"
  cp ${license} LICENSE.broadcom_bcm43xx
''
