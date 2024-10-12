{pkgs, ...}: {
  home.packages = with pkgs; [
    # zsh
    zsh-powerlevel10k
    zsh-fast-syntax-highlighting
    zsh-autosuggestions



    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    neovim
    pfetch-rs
    htop
    tmux
    lf
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq # yaml processer
    fzf # A command-line fuzzy finder
    socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing

    # devops tools
    terraform
    kubectl
    kubectxterraform
    kubectl
    kubectx
    kubernetes-helm
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.gke-gcloud-auth-plugin
    ])
    argocd

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    tldr
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
