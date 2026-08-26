# Starship's zsh init hardcodes both PROMPT and a second RPROMPT that forks
# `starship prompt --right`. With no `right_format` configured that fork renders
# an empty string, so it is 13-17ms of pure latency on every prompt. Dropping
# RPROMPT changes nothing visible.
#
# `transient_rprompt` above is retained deliberately: it costs nothing while
# RPROMPT is empty and keeps the intended behaviour if one is added later.
RPROMPT=''
