# Functions {{{

# 1password
opon() {
  op whoami &> /dev/null
  if [[ $? -ne 0 ]]; then
    eval $(op signin --account homebot)
  fi
}

opoff() {
  echo "opoff not implemented"
  # TODO: this doesn't work anymore
  # op signout
  # unset OP_SESSION_homebot
}

# AWSVault
avprod() {
  aws-vault exec --mfa-token="$(op item get aws-prod --otp)" prod --duration=8h
}

avnexus() {
  aws-vault exec --mfa-token="$(op item get aws-nexus --otp)" nexus --duration=8h
}

avdev() {
  aws-vault exec --mfa-token="$(op item get aws-dev --otp)" dev --duration=8h
}

avsftp() {
  aws-vault exec --mfa-token="$(op item get aws-sftp --otp)" sftp --duration=8h
}

# VSCode
code() {
  VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;
}

# Misc
gen_colors () {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

# pritunl
# sxrfgfri6vfyjbf6y5pwxc5xaa    pritunl.dev.hmbt.co                                      Dev - Data & Infra              4 years ago
# 43agfs2n3jaynmshoqtxeim4eu    pritunl-dev                                              Private                         3 years ago
# bljhr2m3w55e2gcqe75dc2kpji    pritunl-nexus                                            Private                         8 months ago
# i2iokabxpml4ep55pkiwjihcf4    pritunl-bev                                              Private                         1 year ago
# vlhtmhmw4zg7vdqcto6uj76ohe    pritunl-data                                             Private                         3 years ago
# oefimw4a3jdfhnqau7fu3hgc6e    pritunl-prod                                             Private                         3 years ago
vpnon() {
  opon
  if [[ $1 == "dev" ]]
  then
    echo "use bev instead of dev"
    # PW=$(op item get 43agfs2n3jaynmshoqtxeim4eu --fields label=password)
    # OTP=$(op item get 43agfs2n3jaynmshoqtxeim4eu --otp)
    # /Applications/Pritunl.app/Contents/Resources/pritunl-client start tyrkdgrxvvtiopkt --password "$PW$OTP"
  elif [[ $1 == "data" ]];
  then
    PW=$(op item get vlhtmhmw4zg7vdqcto6uj76ohe --fields label=password)
    OTP=$(op item get vlhtmhmw4zg7vdqcto6uj76ohe --otp)
    /Applications/Pritunl.app/Contents/Resources/pritunl-client start 395ld93i3exs8n7i --password "$PW$OTP"
  elif [[ $1 == "prod" ]];
  then
    PW=$(op item get oefimw4a3jdfhnqau7fu3hgc6e --fields label=password)
    OTP=$(op item get oefimw4a3jdfhnqau7fu3hgc6e --otp)
    /Applications/Pritunl.app/Contents/Resources/pritunl-client start xmm40rfvrrgdz4vr --password "$PW$OTP"
  elif [[ $1 == "bev" ]];
  then
    PW=$(op item get i2iokabxpml4ep55pkiwjihcf4 --fields label=password)
    OTP=$(op item get i2iokabxpml4ep55pkiwjihcf4 --otp)
    /Applications/Pritunl.app/Contents/Resources/pritunl-client start jqu7kagnrmnk6mil --password "$PW$OTP"
  elif [[ $1 == "nexus" ]];
  then
    PW=$(op item get bljhr2m3w55e2gcqe75dc2kpji --fields label=password)
    OTP=$(op item get bljhr2m3w55e2gcqe75dc2kpji --otp)
    /Applications/Pritunl.app/Contents/Resources/pritunl-client start 654cbff780fc77ed --password "$PW$OTP"
  elif [[ $1 == "forge" ]];
  then
    PW=$(op item get x3v2a3tynucrpaewsepodabh2m --fields label=password)
    OTP=$(op item get x3v2a3tynucrpaewsepodabh2m --otp)
    /Applications/Pritunl.app/Contents/Resources/pritunl-client start 8melsoswoe8cmme9 --password "$PW$OTP"
  else
    echo "Unknown account"
  fi
}

vpnoff() {
  if [[ $1 == "dev" ]]
  then
    /Applications/Pritunl.app/Contents/Resources/pritunl-client stop tyrkdgrxvvtiopkt
  elif [[ $1 == "data" ]];
  then
    /Applications/Pritunl.app/Contents/Resources/pritunl-client stop 395ld93i3exs8n7i
  elif [[ $1 == "prod" ]];
  then
    /Applications/Pritunl.app/Contents/Resources/pritunl-client stop xmm40rfvrrgdz4vr
  elif [[ $1 == "bev" ]];
  then
    /Applications/Pritunl.app/Contents/Resources/pritunl-client stop jqu7kagnrmnk6mil
  elif [[ $1 == "nexus" ]];
  then
    /Applications/Pritunl.app/Contents/Resources/pritunl-client stop 654cbff780fc77ed
  elif [[ $1 == "forge" ]];
  then
    /Applications/Pritunl.app/Contents/Resources/pritunl-client stop 8melsoswoe8cmme9
  else
    echo "Unknown account"
  fi
}
# End functions }}}


