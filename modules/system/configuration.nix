{ config, lib, pkgs, vm-configs, ... }:
{
  # Basic system settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "transparent_hugepage=never" ];


  networking = {
    hostName = "${vm-configs.host}";
  };

  users.users."${vm-configs.user}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "${vm-configs.password}";
  };
  environment.systemPackages = with pkgs; [
  ];

  # ... other system configurations
  #
  services.redis.servers = builtins.listToAttrs (
    map (portNum: {
      name = "${vm-configs.nodeName}-${toString portNum}";
      value = {
        enable = true;
        port = portNum;
        bind = "0.0.0.0"; # Bind to all interfaces to allow inter-VM communication
        settings = {
          cluster-enabled = "yes";
          cluster-config-file = "nodes.conf";
          cluster-node-timeout = "5000";
          appendonly = "yes";
          protected-mode = "no"; ## allow host to connect to VM
        };
        };

    }) (lib.lists.range vm-configs.startPortNum vm-configs.endPortNum )
  );

  # OpenSSH Service
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true; # Set to false if using keys
      PermitRootLogin = "yes"; # Use "prohibit-password" for better security
    };
  };

  # Open the required ports in the firewall
  networking.firewall.enable = false;

  system.stateVersion = "26.05";
}
