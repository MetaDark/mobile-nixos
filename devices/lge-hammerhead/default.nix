{ config, lib, pkgs, ... }:

let
  allowUnfreePredicate = config.nixpkgs.config.allowUnfreePredicate or
    (pkg: config.nixpkgs.config.allowUnfree or pkg.meta.license.free or true);

  firmware = pkgs.callPackage ./firmware { };
in
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
    kernel = {
      package = pkgs.callPackage ./kernel {
        dtb = "qcom-msm8974-lge-nexus5-hammerhead";
      };

      # Source: https://gitlab.com/postmarketOS/pmaports/-/blob/9ae9a7eb2c70d6b23e52826f3c63c84117680003/device/testing/device-lg-hammerhead/deviceinfo
      modular = true;
      modules = [
        "pm8941_pwrkey" "qnoc_msm8974" "rmi_i2c"
      ];
    };

    firmware = with firmware; [
      # GPU firmware
      adreno330
    ];
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

  boot = {
    # Source: https://gitlab.com/postmarketOS/pmaports/-/blob/9ae9a7eb2c70d6b23e52826f3c63c84117680003/device/testing/device-lg-hammerhead/modules-load.conf
    kernelModules = [
      # Wi-Fi module
      "brcmfmac"
    ];

    # Source: https://gitlab.com/postmarketOS/pmaports/-/blob/9ae9a7eb2c70d6b23e52826f3c63c84117680003/device/testing/device-lg-hammerhead/deviceinfo
    kernelParams = [
      "console=tty0"
      "console=ttyMSM0,115200,n8"
      "PMOS_NO_OUTPUT_REDIRECT"
    ];
  };

  hardware.firmware = with pkgs; with firmware; [
    # Wi-Fi firmware
    bcm4399
    bcm4399-config
    wireless-regdb
  ] ++ lib.optional (allowUnfreePredicate firmware.bcm4335c0)
    # Bluetooth firmware
    firmware.bcm4335c0;

  mobile.system.type = "android";

  # TODO: Figure out why none of the gadgetfs functions work
  # mobile.usb.mode = "gadgetfs";
  mobile.usb.mode = null;

  # Google
  mobile.usb.idVendor = "18D1";
  # Nexus/Pixel Device
  # Product id differs based on mode (See https://devicehunt.com/view/type/usb/vendor/18D1)
  # Use charging + debug mode by default
  mobile.usb.idProduct = "4EE7";

  mobile.usb.gadgetfs.functions = {
    # Uncaught Exception
    # Device or resource busy (Errno:EBUSY)
    # However, USB networking still works when mobile.usb.mode = null
    rndis = "rndis.usb0";

    # hangs at vendor boot screen (seems to never start stage-1?)
    mass_storage = "mass_storage.0";

    # Uncaught Exception
    # Device or resource busy (Errno:EBUSY)
    adb = "ffs.adb";
  };
}
