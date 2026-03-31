{ config, pkgs, ... }:

{
  home.username = "admin";
  home.homeDirectory = "/home/admin";
  home.stateVersion = "23.11"; # Match your initial install version

  # This is where your user-specific apps go now
  home.packages = with pkgs; [
    vlc
    # any other user apps...
  ];

  # VLC Config
  home.file.".config/vlc/vlcrc".text = ''
    [core]
    # Allow metadata = no
    metadata-network-access=0
    # Show hidden files = yes
    show-hiddenfiles=1
    # Playlist: display playlist tree = yes
    playlist-tree=1
    # Subdirectory behaviour = expand (0=default, 1=collapse, 2=expand)
    recursive=2
    # Play files randomly forever = yes
    random=1
    loop=1

    [qt]
    # Privacy popups = no
    qt-privacy-ask=0
    qt-notification=0
    # Resize video to interface = no
    qt-video-autoresize=0
  '';

  # Tor browser
  home.file.".tor-browser/profile.default/prefs.js".text = ''
    user_pref("javascript.enabled", false);
  '';



  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
