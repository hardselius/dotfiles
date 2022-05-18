{ pkgs, ... }: {
  boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "uhci_hcd" "ehci_pci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = { 
    device = "/dev/disk/by-uuid/918111de-0d4f-428a-b69f-45aa768316c4";
    fsType = "ext4";
  };

  swapDevices = [ ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.ens33.useDHCP = true;

  virtualisation = {
    vmware.guest.enable = true;
  };

  environment = {
    pathsToLink = [ "/libexec" ];
    systemPackages = with pkgs; [
      wget
      firefox
    ];
  };

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    pcscd.enable = true;
    xserver = {
      enable = true;

      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          dmenu
          i3status
          i3lock
        ];
      };
      displayManager.defaultSession = "none+i3";
    };
  };
}
