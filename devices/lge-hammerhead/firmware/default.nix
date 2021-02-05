{ callPackage }:

let
  broadcom-hammerhead = callPackage ./broadcom-hammerhead { };
in
{
  adreno330 = callPackage ./adreno330 { };
  bcm4335c0 = broadcom-hammerhead.bcm4335c0;
  bcm4399 = callPackage ./bcm4399 { };
  bcm4399-config = callPackage ./bcm4399-config { };
}
