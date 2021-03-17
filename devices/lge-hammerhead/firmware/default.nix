{ callPackage }:

{
  bcm4399 = callPackage ./bcm4399 { };
  bcm4399-config = callPackage ./bcm4399-config { };
}
