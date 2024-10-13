{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    initExtra = ''
      source "$XDG_CONFIG_HOME/zsh/.zshrc"
      if command -v pfetch &> /dev/null; then
          pfetch
      fi
    '';
    shellAliases = {
      dot = "git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME";
      v = "nvim";
      c = "code";
      ll = "ls -lSGh";
      tf = "terraform";
      dc = "docker-compose";

      g = "git";
      gc = "git clone";
      gf = "git fetch";
      gps = "git push";
      gpl = "git pull";
      gpso = "git push origin";
      gplo = "git pull origin";
      gpsm = "git push origin main";
      gplm = "git pull origin main";
      gb = "git branch";
      gch = "git checkout";
      gcb = "git checkout -b";
      gcm = "git checkout main";
      gl = "git log";
      gll = "git ll";
      gs = "git stash";
      gsl = "git stash list";
      gsa = "git stash apply";
      gsd = "git stash drop";

      k = "kubectl";
      kg = "kubectl get";
      kd = "kubectl describe";
      kl = "kubectl logs";
      ke = "kubectl explain";
      kn = "kubens";
      kc = "kubectx";
      kgp = "kubectl get pod";
      kgsv = "kubectl get service";
      kgd = "kubectl get deploy";
      kgpa = "kubectl get pods -A";
      kgsa = "kubectl get secrets -A";
      kgna = "kubectl get nodes -A";
      kgrc = "kubectl get rc";
      kgn = "kubectl get node";
      kgs = "kubectl get secret";
      kdp = "kubectl describe pod";
      kds = "kubectl describe service";
      kdd = "kubectl describe deploy";
      keit = "kubectl exec -it";
      ktop = "kubectl top nodes";
      kevent = "kubectl get events";
    };
    envExtra = ''
      source "$XDG_CONFIG_HOME/zsh/env"
    '';
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };
}
