{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "broadcom-hammerhead";
  imageVersion = "m4b30z";
  rev = "21cf8433";
  version = "${imageVersion}-${rev}";
  outputs = [ "out" "bcm4335c0" ];

  src = fetchurl {
    url = "https://dl.google.com/dl/android/aosp/${pname}-${version}.tgz";
    hash = "sha256-G9i8APP0ESYoAnRK9fY9BHMyqSErxsOLJUAHBLiFED4=";
  };

  # Work around the "unpacker appears to have produced no directories"
  # case that happens when the archive doesn't have a subdirectory.
  setSourceRoot = "sourceRoot=`pwd`";

  # Automatically accept license and extract
  postUnpack = ''
    head -n 240 extract-broadcom-hammerhead.sh | tail -n +16 > LICENSE
    tail -n +276 extract-broadcom-hammerhead.sh | tar -zx
  '';

  installPhase = ''
    mkdir -p "$out" "$bcm4335c0/lib/firmware/brcm" "$bcm4335c0/share/licenses/${pname}"
    cp vendor/broadcom/hammerhead/proprietary/bcm4335c0.hcd "$bcm4335c0/lib/firmware/brcm/BCM4335C0.hcd"
    cp LICENSE "$bcm4335c0/share/licenses/${pname}"
  '';

  meta = with lib; {
    description = "Broadcom drivers for the Nexus 5";
    homepage = "https://developers.google.com/android/drivers#hammerhead";
    license = licenses.unfree;
    maintainers = with maintainers; [ metadark ];
  };
}
