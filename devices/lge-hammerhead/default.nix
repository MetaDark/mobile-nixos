{ pkgs, ... }:

{
  mobile.device.name = "lge-hammerhead";
  mobile.device.identity = {
    name = "Nexus 5";
    manufacturer = "LGE";
  };

  mobile.hardware = {
    soc = "qualcomm-msm8974";
    ram = 1024 * 2;
    screen = {
      width = 1080; height = 1920;
    };
  };

  mobile.boot.stage-1 = {
    kernel.package = pkgs.callPackage ./kernel { };
  };

  mobile.system.android = {
    bootimg.flash = {
      offset_base = "0x00000000";
      offset_kernel = "0x00008000";
      offset_ramdisk = "0x02900000";
      offset_second = "0x00f00000";
      offset_tags = "0x02700000";
      pagesize = "2048";
    };
  };

  boot.kernelParams = [
    # Extracted from an Android boot image
    "console=ttyHSL0,115200,n8"
    "androidboot.hardware=hammerhead"
    "user_debug=31"
    "maxcpus=2"
    "msm_watchdog_v2.enable=1"
  ];

  mobile.system.type = "android";

  mobile.usb.mode = "gadgetfs";

  # Google
  mobile.usb.idVendor = "18D1";
  # Nexus/Pixel Device
  # Product id differs based on mode (See https://devicehunt.com/view/type/usb/vendor/18D1)
  # Use charging + debug mode by default
  mobile.usb.idProduct = "4EE7";

  mobile.usb.gadgetfs.functions = {
    rndis = "rndis.usb0";
    mass_storage = "mass_storage.0";
    adb = "ffs.adb";
  };
}
