{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    settings = {
      user.name = "Dylan Meskis";
      user.email = "dmeskis@gmail.com";

      alias = {
        b = "branch --color -v";
        branches = "branch -a";
        changes = "diff --name-status -r";
        clone = "clone --recursive";
        co = "checkout";
        cp = "cherry-pick";
        ri = "rebase --interactive";
        st = "status";
        tags = "tag -l";
        undo = "reset --soft HEAD^";
      };

      color.ui = true;
      color.branch = {
        current = "magenta reverse";
        local = "yellow";
        remote = "green";
      };
      color.diff = {
        meta = "yellow bold";
        frag = "magenta bold";
        old = "red bold";
        new = "green bold";
      };
      color.status = {
        added = "green";
        changed = "yellow";
        untracked = "cyan";
        branch = "magenta";
        nobranch = "normal";
        unmerged = "red";
      };

      pager = {
        # diff/log/show/blame come from programs.delta.enableGitIntegration.
        reflog = "delta";
        branch = false;
      };

      push.autoSetupRemote = true;
    };

    ignores = [
      "*~"
      "*.swp"
      "*.pyc"
      ".bundle"
      ".direnv/"
      ".DS_STORE"
      ".envrc"
      ".envrc.cache"
      ".envrc.override"
      "venv/**/*"
      ".idea/**/*"
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      side-by-side = true;
    };
  };
}
