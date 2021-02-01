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
    # Source: https://gitlab.com/postmarketOS/pmaports/-/blob/9ae9a7eb2c70d6b23e52826f3c63c84117680003/device/testing/device-lg-hammerhead/deviceinfo
    kernelParams = [
      "console=tty0"
      "console=ttyMSM0,115200,n8"
      "PMOS_NO_OUTPUT_REDIRECT"
    ];
  };

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
