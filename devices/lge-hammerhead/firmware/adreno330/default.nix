{ lib, fetchurl, runCommand, firmwareLinuxNonfree }:

let
  pname = "adreno330-firmware";

  # firmwareLinuxNonfree currently violates LICENSE.qcom by not
  # including the license with the firmware. Until that's fixed
  # upstream, patch it in manually.
  linuxFirmwareRev = "05789708b79b38eb0f1a20d8449b4eb56d39b39f";
  license = fetchurl {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/LICENSE.qcom?id=${linuxFirmwareRev}";
    hash = "sha256-vpBM0oyykrgM22z0EqsNkVnUMWcemHrUM8H2LgmIqbw=";
  };
in
runCommand "${pname}-${firmwareLinuxNonfree.version}" {
  meta = with lib; {
    inherit (firmwareLinuxNonfree.meta) homepage license;
    description = "GPU drivers for the Nexus 5";
    maintainers = with maintainers; [ metadark ];
  };
} ''
  mkdir -p "$out/lib/firmware/qcom" "$out/share/licenses/${pname}"

  cd "$out/lib/firmware/qcom"
  cp ${firmwareLinuxNonfree}/lib/firmware/qcom/a300_pfp.fw a330_pfp.fw
  cp ${firmwareLinuxNonfree}/lib/firmware/qcom/a300_pm4.fw a330_pm4.fw

  cd "$out/share/licenses/${pname}"
  cp ${license} LICENSE.qcom
''
