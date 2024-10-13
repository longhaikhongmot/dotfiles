{ pkgs, ... }: {
  home.packages = with pkgs; [
    # zsh
    zsh-powerlevel10k
    zsh-fast-syntax-highlighting
    zsh-autosuggestions
  ];
}
