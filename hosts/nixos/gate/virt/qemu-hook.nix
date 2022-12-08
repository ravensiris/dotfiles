{ pkgs, ... }:

{
  systemd.services.libvirtd.preStart =
    let
      qemuHook = pkgs.writeScript "qemu-hook" ''
        #!${pkgs.stdenv.shell}

        GUEST_NAME="$1"
        OPERATION="$2"
        SUB_OPERATION="$3"

        if [[ "$GUEST_NAME" == "win11"* ]]; then
          if [[ "$OPERATION" == "started" ]]; then
            systemctl set-property --runtime -- system.slice AllowedCPUs=0,12,8,20,9,21,10,22,11,23
            systemctl set-property --runtime -- user.slice AllowedCPUs=0,12,8,20,9,21,10,22,11,23
            systemctl set-property --runtime -- init.scope AllowedCPUs=0,12,8,20,9,21,10,22,11,23
          fi

          if [[ "$OPERATION" == "stopped" ]]; then
            systemctl set-property --runtime -- user.slice AllowedCPUs=0-23
            systemctl set-property --runtime -- system.slice AllowedCPUs=0-23
            systemctl set-property --runtime -- init.scope AllowedCPUs=0-23
          fi
        fi
      '';
    in
    ''
      mkdir -p /var/lib/libvirt/hooks
      chmod 755 /var/lib/libvirt/hooks

      # Copy hook files
      ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
    '';
}
