{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.s3fs;
in {
  options.s3fs = mkOption {
    type = types.attrsOf (types.submodule {
      options = {
        mountPath = mkOption {
          type = types.str;
        };
      };
    });

    default = {};
  };

  config = {
    users.groups.media = {};
    systemd.services =
      lib.mapAttrs' (name: cfg: {
        name = "s3fs-${name}";
        value = {
          wantedBy = ["multi-user.target"];
          after = ["network.target"];
          serviceConfig = {
            Group = "media";
            ExecStartPre = [
              "${pkgs.coreutils}/bin/mkdir -m 0500 -pv ${cfg.mountPath}"
              "${pkgs.e2fsprogs}/bin/chattr +i ${cfg.mountPath}" # Stop files being accidentally written to unmounted directory
            ];
            ExecStart = let
              options = [
                "use_path_request_style"
                "allow_other"
                "url=http://192.168.88.35:9000"
                "umask=0007"
              ];
            in
              "${pkgs.s3fs}/bin/s3fs ${name} ${cfg.mountPath} -f "
              + lib.concatMapStringsSep " " (opt: "-o ${opt}") options;
            ExecStopPost = "-${pkgs.fuse}/bin/fusermount -u ${cfg.mountPath}";
            KillMode = "process";
            Restart = "on-failure";
            EnvironmentFile = "/run/agenix/${name}-bucket";
          };
        };
      })
      cfg;
  };
}
