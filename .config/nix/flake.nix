{
  description = "Long flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {
      # Install unfree packages
      nixpkgs.config.allowUnfree = true;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
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
        nixpkgs-fmt # nix code formatter

        # devops tools
        terraform
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

      homebrew = {
        enable = true;
        taps = [
          "homebrew/services"
        ];

        # `brew install`
        # TODO Feel free to add your favorite apps here.
        brews = [
          "wget" # download tool
          "curl" # no not install curl via nixpkgs, it's not working well on macOS!
          "watch"
          "iproute2mac"
        ];

        # `brew install --cask`
        # TODO Feel free to add your favorite apps here.
        casks = [
          "firefox"
          "visual-studio-code"
          "raycast" # (HotKey: alt/option + space)search, caculate and run scripts(with many plugins)
          "stats" # beautiful system monitor
          "calibre"

          # Development
          "insomnia" # REST client
        ];
        onActivation.cleanup = "zap";
        onActivation.upgrade = true;
        onActivation.autoUpdate = true;
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      programs.zsh.promptInit = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
      '';
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "x86_64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake ~/.config/nix/#mac
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            user = "longnguyen23";
            enable = true;
            autoMigrate = true;
          };
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mac".pkgs;
  };
}