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
  opon
  aws-vault exec --mfa-token="$(op item get aws-prod --otp)" prod --duration=8h
}

avdev() {
  opon
  aws-vault exec --mfa-token="$(op item get aws-dev --otp)" dev --duration=8h
}

avsftp() {
  opon
  aws-vault exec --mfa-token="$(op item get aws-sftp --otp)" sftp --duration=8h
}

# VSCode
code() {
  VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;
}

# AWSVault
avprod() {
  opon
  aws-vault exec --mfa-token="$(op item get aws-prod --otp)" prod --duration=8h
}

avdev() {
  opon
  aws-vault exec --mfa-token="$(op item get aws-dev --otp)" dev --duration=8h
}

avsftp() {
  opon
  aws-vault exec --mfa-token="$(op item get aws-sftp --otp)" sftp --duration=8h
}


# Misc
gen_colors () {
  for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

# pritunl
hbvpn() {
  opon
  if [[ $1 == "dev" ]]
  then
    PW=$(op item get pritunl-dev --fields label=password)
    OTP=$(op item get pritunl-dev --otp)
    /Applications/Pritunl.app/Contents/Resources/pritunl-client start tyrkdgrxvvtiopkt --password "$PW$OTP"
  elif [[ $1 == "data" ]];
  then
    PW=$(op item get pritunl-data --fields label=password)
    OTP=$(op item get pritunl-data --otp)
    /Applications/Pritunl.app/Contents/Resources/pritunl-client start 395ld93i3exs8n7i --password "$PW$OTP"
  elif [[ $1 == "prod" ]];
  then
    PW=$(op item get pritunl-prod --fields label=password)
    OTP=$(op item get pritunl-prod --otp)
    /Applications/Pritunl.app/Contents/Resources/pritunl-client start xmm40rfvrrgdz4vr --password "$PW$OTP"
  elif [[ $1 == "bev" ]];
  then
    PW=$(op item get pritunl-bev --fields label=password)
    OTP=$(op item get pritunl-bev --otp)
    /Applications/Pritunl.app/Contents/Resources/pritunl-client start jqu7kagnrmnk6mil --password "$PW$OTP"
  else
    echo "Unknown account"
  fi
}
# End functions }}}

eval "$(rbenv init - zsh)"

