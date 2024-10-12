{pkgs, ...}: {
  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq # yaml processer
    fzf # A command-line fuzzy finder
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
  ];

  programs = {
    
    # modern vim
    # neovim = {
    #   enable = true;
    #   defaultEditor = true;
    #   vimAlias = true;
    # };
  };
}
