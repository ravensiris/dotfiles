{
  pkgs,
  config,
  lib,
  ...
}: let
  alloc_hugepages = pkgs.writeScriptBin "alloc_hugepages" ''
    #!${pkgs.bash}/bin/bash

    ## Calculate number of hugepages to allocate from memory (in MB)
    HUGEPAGES="$(($MEMORY/$(($(grep Hugepagesize /proc/meminfo | ${pkgs.gawk}/bin/awk '{print $2}')/1024))))"

    echo "Allocating hugepages..." > /dev/kmsg
    echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
    ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)

    TRIES=0
    while (( $ALLOC_PAGES != $HUGEPAGES && $TRIES < 1000 ))
    do
        echo 1 > /proc/sys/vm/compact_memory            ## defrag ram
        echo $HUGEPAGES > /proc/sys/vm/nr_hugepages
        ALLOC_PAGES=$(cat /proc/sys/vm/nr_hugepages)
        echo "Succesfully allocated $ALLOC_PAGES / $HUGEPAGES"  > /dev/kmsg
        let TRIES+=1
    done

    if [ "$ALLOC_PAGES" -ne "$HUGEPAGES" ]
    then
        echo "Not able to allocate all hugepages. Reverting..."  > /dev/kmsg
        echo 0 > /proc/sys/vm/nr_hugepages
        exit 1
    fi
  '';

  dealloc_hugepages = pkgs.writeScriptBin "dealloc_hugepages" ''
    #!${pkgs.bash}/bin/bash

    echo "Deallocating hugepages"  > /dev/kmsg
    echo 0 > /proc/sys/vm/nr_hugepages
  '';

  # 2 threads will get allocated to IO
  allocated_cpus = 8;
  cpu_tuples = builtins.genList (i: [i (i + 12)]) 12;
  cpus = lib.flatten cpu_tuples;
  cpus_with_index = lib.zipLists (lib.range 0 (builtins.length cpus)) cpus;
  vcpupins = lib.concatStringsSep "\n    " (lib.take (allocated_cpus * 2 - 4) (builtins.map (x: "<vcpupin vcpu='${toString x.fst}' cpuset='${toString x.snd}'/>") cpus_with_index));
  reserved_cpus = lib.takeEnd 4 (lib.take (allocated_cpus * 2) cpus);
  emulator_pin = "<emulatorpin cpuset='${toString (lib.elemAt reserved_cpus 0)},${toString (lib.elemAt reserved_cpus 1)}'/>";
  iothread_pin = "<iothreadpin iothread='1' cpuset='${toString (lib.elemAt reserved_cpus 2)},${toString (lib.elemAt reserved_cpus 3)}'/>";
  free_cpus = lib.takeEnd ((builtins.length cpus) - allocated_cpus * 2) cpus;
  allowed_cpus = lib.concatStringsSep "," (builtins.map toString free_cpus);
  win11Xml = ''
    <domain type='kvm' xmlns:qemu='http://libvirt.org/schemas/domain/qemu/1.0'>
      <name>win11</name>
      <uuid>65dbe74c-49cd-415e-a6cb-101312fb6f3b</uuid>
      <metadata>
        <libosinfo:libosinfo xmlns:libosinfo="http://libosinfo.org/xmlns/libvirt/domain/1.0">
          <libosinfo:os id="http://microsoft.com/win/11"/>
        </libosinfo:libosinfo>
      </metadata>
      <memory unit='KiB'>33554432</memory>
      <currentMemory unit='KiB'>33554432</currentMemory>
      <memoryBacking>
        <hugepages/>
      </memoryBacking>
      <vcpu placement='static'>16</vcpu>
      <iothreads>1</iothreads>
      <cputune>
        ${vcpupins}
        ${emulator_pin}
        ${iothread_pin}
      </cputune>
      <os>
        <type arch='x86_64' machine='pc-q35-7.0'>hvm</type>
        <loader readonly='yes' secure='yes' type='pflash' format='raw'>/etc/ovmf/edk2-x86_64-secure-code.fd</loader>
        <nvram template='/etc/ovmf/edk2-i386-vars.fd' format='raw'>/var/lib/libvirt/qemu/nvram/win11_VARS.fd</nvram>
        <bootmenu enable='no'/>
      </os>
      <features>
        <acpi/>
        <apic/>
        <hyperv mode='custom'>
          <relaxed state='on'/>
          <vapic state='on'/>
          <spinlocks state='on' retries='8191'/>
          <vendor_id state='on' value='kvm hyperv'/>
        </hyperv>
        <vmport state='off'/>
        <smm state='on'/>
        <ioapic driver='kvm'/>
      </features>
      <cpu mode='custom' match='exact' check='none'>
        <model fallback='allow'>EPYC-Rome</model>
        <topology sockets='1' dies='1' clusters='1' cores='8' threads='2'/>
        <feature policy='require' name='topoext'/>
      </cpu>
      <clock offset='localtime'>
        <timer name='rtc' tickpolicy='catchup'/>
        <timer name='pit' tickpolicy='delay'/>
        <timer name='hpet' present='no'/>
        <timer name='hypervclock' present='yes'/>
      </clock>
      <on_poweroff>destroy</on_poweroff>
      <on_reboot>restart</on_reboot>
      <on_crash>destroy</on_crash>
      <pm>
        <suspend-to-mem enabled='no'/>
        <suspend-to-disk enabled='no'/>
      </pm>
      <devices>
        <emulator>/run/libvirt/nix-emulators/qemu-system-x86_64</emulator>
        <disk type='file' device='cdrom'>
          <driver name='qemu' type='raw'/>
          <target dev='sda' bus='sata'/>
          <readonly/>
          <boot order='1'/>
          <address type='drive' controller='0' bus='0' target='0' unit='0'/>
        </disk>
        <controller type='usb' index='0' model='qemu-xhci' ports='15'>
          <address type='pci' domain='0x0000' bus='0x02' slot='0x00' function='0x0'/>
        </controller>
        <controller type='pci' index='0' model='pcie-root'/>
        <controller type='pci' index='1' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='1' port='0x8'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0' multifunction='on'/>
        </controller>
        <controller type='pci' index='2' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='2' port='0x9'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x1'/>
        </controller>
        <controller type='pci' index='3' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='3' port='0xa'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x2'/>
        </controller>
        <controller type='pci' index='4' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='4' port='0xb'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x3'/>
        </controller>
        <controller type='pci' index='5' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='5' port='0xc'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x4'/>
        </controller>
        <controller type='pci' index='6' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='6' port='0xd'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x5'/>
        </controller>
        <controller type='pci' index='7' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='7' port='0xe'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x6'/>
        </controller>
        <controller type='pci' index='8' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='8' port='0xf'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x7'/>
        </controller>
        <controller type='pci' index='9' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='9' port='0x10'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x0' multifunction='on'/>
        </controller>
        <controller type='pci' index='10' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='10' port='0x11'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x1'/>
        </controller>
        <controller type='pci' index='11' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='11' port='0x12'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x2'/>
        </controller>
        <controller type='pci' index='12' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='12' port='0x13'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x3'/>
        </controller>
        <controller type='pci' index='13' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='13' port='0x14'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x4'/>
        </controller>
        <controller type='pci' index='14' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='14' port='0x15'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x5'/>
        </controller>
        <controller type='pci' index='15' model='pcie-root-port'>
          <model name='pcie-root-port'/>
          <target chassis='15' port='0x16'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x02' function='0x6'/>
        </controller>
        <controller type='pci' index='16' model='pcie-to-pci-bridge'>
          <model name='pcie-pci-bridge'/>
          <address type='pci' domain='0x0000' bus='0x06' slot='0x00' function='0x0'/>
        </controller>
        <controller type='sata' index='0'>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x1f' function='0x2'/>
        </controller>
        <controller type='scsi' index='0' model='lsilogic'>
          <address type='pci' domain='0x0000' bus='0x10' slot='0x02' function='0x0'/>
        </controller>
        <controller type='virtio-serial' index='0'>
          <address type='pci' domain='0x0000' bus='0x07' slot='0x00' function='0x0'/>
        </controller>
        <interface type='bridge'>
          <mac address='52:54:00:e2:27:cb'/>
          <source bridge='br0'/>
          <model type='virtio'/>
          <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
        </interface>
        <channel type='spicevmc'>
          <target type='virtio' name='com.redhat.spice.0'/>
          <address type='virtio-serial' controller='0' bus='0' port='1'/>
        </channel>
        <input type='mouse' bus='ps2'/>
        <input type='keyboard' bus='virtio'>
          <address type='pci' domain='0x0000' bus='0x08' slot='0x00' function='0x0'/>
        </input>
        <input type='keyboard' bus='ps2'/>
        <input type='evdev'>
          <source dev='/dev/input/by-id/usb-liliums_Lily58-event-kbd' grab='all' grabToggle='scrolllock' repeat='on'/>
        </input>
        <tpm model='tpm-crb'>
          <backend type='emulator' version='2.0'/>
        </tpm>
        <graphics type='spice' autoport='yes'>
          <listen type='address'/>
          <image compression='off'/>
          <gl enable='no'/>
        </graphics>
        <sound model='ich9'>
          <audio id='1'/>
          <address type='pci' domain='0x0000' bus='0x00' slot='0x1b' function='0x0'/>
        </sound>
        <audio id='1' type='pulseaudio' serverName='/run/user/1000/pulse/native'>
          <input mixingEngine='no'/>
          <output mixingEngine='no'/>
        </audio>
        <video>
          <model type='none'/>
        </video>
        <hostdev mode='subsystem' type='pci' managed='yes'>
          <source>
            <address domain='0x0000' bus='0x06' slot='0x00' function='0x1'/>
          </source>
          <address type='pci' domain='0x0000' bus='0x05' slot='0x00' function='0x0'/>
        </hostdev>
        <hostdev mode='subsystem' type='pci' managed='yes'>
          <source>
            <address domain='0x0000' bus='0x06' slot='0x00' function='0x3'/>
          </source>
          <address type='pci' domain='0x0000' bus='0x09' slot='0x00' function='0x0'/>
        </hostdev>
        <hostdev mode='subsystem' type='pci' managed='yes'>
          <source>
            <address domain='0x0000' bus='0x0d' slot='0x00' function='0x0'/>
          </source>
          <address type='pci' domain='0x0000' bus='0x04' slot='0x00' function='0x0'/>
        </hostdev>
        <hostdev mode='subsystem' type='pci' managed='yes'>
          <source>
            <address domain='0x0000' bus='0x0d' slot='0x00' function='0x1'/>
          </source>
          <address type='pci' domain='0x0000' bus='0x0a' slot='0x00' function='0x0'/>
        </hostdev>
        <hostdev mode='subsystem' type='pci' managed='yes'>
          <source>
            <address domain='0x0000' bus='0x07' slot='0x00' function='0x0'/>
          </source>
          <address type='pci' domain='0x0000' bus='0x03' slot='0x00' function='0x0'/>
        </hostdev>
        <redirdev bus='usb' type='spicevmc'>
          <address type='usb' bus='0' port='4'/>
        </redirdev>
        <redirdev bus='usb' type='spicevmc'>
          <address type='usb' bus='0' port='5'/>
        </redirdev>
        <watchdog model='itco' action='reset'/>
        <memballoon model='none'/>
      </devices>
      <qemu:commandline>
        <qemu:arg value='-device'/>
        <qemu:arg value='{&quot;driver&quot;:&quot;ivshmem-plain&quot;,&quot;id&quot;:&quot;shmem0&quot;,&quot;memdev&quot;:&quot;looking-glass&quot;}'/>
        <qemu:arg value='-object'/>
        <qemu:arg value='{&quot;qom-type&quot;:&quot;memory-backend-file&quot;,&quot;id&quot;:&quot;looking-glass&quot;,&quot;mem-path&quot;:&quot;/dev/kvmfr0&quot;,&quot;size&quot;:134217728,&quot;share&quot;:true}'/>
        <qemu:arg value='-smbios'/>
        <qemu:arg value='file=/home/q/Documents/smbios_type_0.bin'/>
      </qemu:commandline>
    </domain>
  '';
in {
  environment.etc."libvirt/win11.xml".text = win11Xml;
  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 root libvirtd -"
  ];
  systemd.services.installWin11Xml = {
    description = "Install win11.xml into libvirt directory";
    after = ["libvirtd.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.coreutils}/bin/cp /etc/libvirt/win11.xml /var/lib/libvirt/qemu/win11.xml
        ${pkgs.coreutils}/bin/chown root:root /var/lib/libvirt/qemu/win11.xml
        ${pkgs.coreutils}/bin/chmod 0644 /var/lib/libvirt/qemu/win11.xml
      '';
    };
  };
  systemd.paths.installWin11XmlPath = {
    pathConfig = {
      PathChanged = "/etc/libvirt/win11.xml";
    };
    wantedBy = ["multi-user.target"];
  };
  systemd.services.libvirtd.preStart = let
    qemuHook = pkgs.writeScript "qemu-hook" ''
      #!${pkgs.bash}/bin/bash

      GUEST_NAME="$1"
      OPERATION="$2"
      SUB_OPERATION="$3"

      if [[ "$GUEST_NAME" == "win11"* ]]; then
        if [[ "$OPERATION" == "prepare" ]]; then
          export MEMORY=32768

          ${alloc_hugepages}/bin/alloc_hugepages
        fi
        if [[ "$OPERATION" == "started" ]]; then
          systemctl set-property --runtime -- system.slice AllowedCPUs=${allowed_cpus}
          systemctl set-property --runtime -- user.slice AllowedCPUs=${allowed_cpus}
          systemctl set-property --runtime -- init.scope AllowedCPUs=${allowed_cpus}
        fi
        if [[ "$OPERATION" == "stopped" ]]; then
          systemctl set-property --runtime -- user.slice AllowedCPUs=0-23
          systemctl set-property --runtime -- system.slice AllowedCPUs=0-23
          systemctl set-property --runtime -- init.scope AllowedCPUs=0-23
          ${dealloc_hugepages}/bin/dealloc_hugepages
        fi
      fi
    '';
  in ''
    mkdir -p /var/lib/libvirt/hooks
    chmod 755 /var/lib/libvirt/hooks
    # Copy hook files
    ln -sf ${qemuHook} /var/lib/libvirt/hooks/qemu
  '';

  boot.kernelParams = ["amd_iommu=on"];

  boot.extraModprobeConfig = ''
    options vfio-pci ids=0a:00.0,0a:00.1
    options snd_hda_intel power_save=0
  '';
  boot.blacklistedKernelModules = [
    "nvidia"
    "nouveau"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidiafb"
  ];
  environment.systemPackages = with pkgs; [
    virt-manager
    looking-glass-client
    qemu
    pciutils
    swtpm
    win-virtio
    quickemu
    alloc_hugepages
    dealloc_hugepages
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.qemu.swtpm.enable = true;

  environment.etc = {
    "ovmf/edk2-x86_64-secure-code.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-x86_64-secure-code.fd";
    };

    "ovmf/edk2-i386-vars.fd" = {
      source = config.virtualisation.libvirtd.qemu.package + "/share/qemu/edk2-i386-vars.fd";
    };
  };

  virtualisation.kvmfr = {
    enable = true;
    shm = {
      enable = true;
      size = 128;
      user = "q";
      group = "libvirtd";
      mode = "0600";
    };
  };
  environment.sessionVariables.LIBVIRT_DEFAULT_URI = ["qemu:///system"];

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    namespaces = []
    cgroup_device_acl = [
        "/dev/input/by-id/usb-liliums_Lily58-event-kbd",
        "/dev/null", "/dev/full", "/dev/zero",
        "/dev/random", "/dev/urandom",
        "/dev/ptmx", "/dev/kvm", "/dev/kqemu",
        "/dev/rtc","/dev/hpet", "/dev/vfio/vfio", "/dev/kvmfr0"
    ]
  '';
}
