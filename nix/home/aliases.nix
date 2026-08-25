{
  reload = "exec \${SHELL} -l";

  ".." = "cd ..";
  "..." = "cd ../..";
  "...." = "cd ../../..";
  "....." = "cd ../../../..";
  "......" = "cd ../../../../..";

  dl = "cd ~/Download";
  dt = "cd ~/Desktop";

  be = "bundle exec ";

  flush = "dscacheutil -flushcache";

  hidedesktop = "defaults write com.apple.finder CreateDesktop -bool false && killall Finder";
  showdesktop = "defaults write com.apple.finder CreateDesktop -bool true && killall Finder";

  x1 = "xargs -n1";

  g = "grep";
  h = "history";

  l = "ls -lAh";
  ll = "ls -la";
  la = "ls -A";

  # git
  cleanup = "git branch --merged | grep -Ev '(^\\*|master|main|dev|homebot)' | xargs -n 1 git branch -d && git remote prune origin";

  l1 = "tree --dirsfirst -ChFL 1";
  l2 = "tree --dirsfirst -ChFL 2";
  l3 = "tree --dirsfirst -ChFL 3";
  ll1 = "tree --dirsfirst -ChFupDaL 1";
  ll2 = "tree --dirsfirst -ChFupDaL 2";
  ll3 = "tree --dirsfirst -ChFupDaL 3";

  # Processes
  k9 = "killall -9";

  dc = "docker-compose";

  vim = "nvim";
  viml = "vim -u NONE";

  tf = "terraform";

  rga = "rg --hidden";
  rgaa = "rg -uu --hidden";
  rgaaa = "rg -uu --glob '!{.git,node_modules,build,dist,tmp}' --hidden";

  snowsql = "/Applications/SnowSQL.app/Contents/MacOS/snowsql";
}
