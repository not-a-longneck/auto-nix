{ config, pkgs, ... }:

{
  home.username = "admin";
  home.homeDirectory = "/home/admin";
  home.stateVersion = "23.11"; # Match your initial install version

  # This is where your user-specific apps go now
  home.packages = with pkgs; [

    vlc
    tor-browser

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

    // --- Privacy & Security ---
    user_pref("javascript.enabled", false);
    user_pref("intl.accept_languages", "en-US, en");
    user_pref("intl.locale.requested", "en-US");

    // --- UI & Behavior ---
    // Hide Bookmark Bar (2 = never)
    user_pref("browser.toolbars.bookmarks.visibility", "never");
    
    // Always connect automatically
    user_pref("extensions.torlauncher.prompt_at_startup", false);
    user_pref("network.bootstrapped", true);

    // --- Extra Hardening ---
    user_pref("privacy.resistFingerprinting", true);
    user_pref("webgl.disabled", true);
    
  '';



  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}
