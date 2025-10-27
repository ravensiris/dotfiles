{
  pkgs,
  lib,
  ...
}: {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
      scripts = [
        pkgs.mpvScripts.autoload
        pkgs.mpvScripts.thumbfast
        pkgs.mpvScripts.sponsorblock
      ];
    };
    config = {
      glsl-shaders = builtins.replaceStrings ["~~"] ["${pkgs.anime4k}/usr/share"] "~~/shaders/Anime4K_Clamp_Highlights.glsl:~~/shaders/Anime4K_Restore_CNN_VL.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:~~/shaders/Anime4K_AutoDownscalePre_x2.glsl:~~/shaders/Anime4K_AutoDownscalePre_x4.glsl:~~/shaders/Anime4K_Upscale_CNN_x2_M.glsl";
    };
    scriptOpts = {
      ytdl_hook = {
        ytdl_path = "${lib.getExe pkgs.unstable.yt-dlp}";
      };
    };
    bindings = {
      "CTRL+1" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A (HQ)"'';
      "CTRL+2" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B (HQ)"'';
      "CTRL+3" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C (HQ)"'';
      "CTRL+4" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode A+A (HQ)"'';
      "CTRL+5" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_Soft_M.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode B+B (HQ)"'';
      "CTRL+6" = ''no-osd change-list glsl-shaders set "${pkgs.anime4k}/usr/share/shaders/Anime4K_Clamp_Highlights.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_Denoise_CNN_x2_VL.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x2.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_AutoDownscalePre_x4.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Restore_CNN_M.glsl:${pkgs.anime4k}/usr/share/shaders/Anime4K_Upscale_CNN_x2_M.glsl"; show-text "Anime4K: Mode C+A (HQ)"'';
      "CTRL+0" = ''no-osd change-list glsl-shaders clr ""; show-text "GLSL shaders cleared"'';
    };
  };

  systemd.user.services.jellyfin-mpv-shim = {
    Unit = {
      Description = "Jellyfin Client";
      After = "network.target";
    };

    Install = {
      WantedBy = ["default.target"];
    };

    Service = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 30";
      ExecStart = "${pkgs.jellyfin-mpv-shim}/bin/jellyfin-mpv-shim";
      ExecStop = "${pkgs.coreutils}/bin/kill -s SIGINT $MAINPID";
      Restart = "on-failure";
    };
  };
}
