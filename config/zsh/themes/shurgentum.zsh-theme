SHOW_AWS_PROMPT=false
KUBE_PS1_PREFIX="%{$fg_bold[blue]%}("
KUBE_PS1_SUFFIX="%{$fg_bold[blue]%})%{$reset_color%}"
KUBE_PS1_SYMBOL_ENABLE=false

ZSH_THEME_AWS_PREFIX="%{$fg_bold[yellow]%}"
ZSH_THEME_AWS_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}|%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%} %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"


STATUS_ARROW="%(?:%{$fg[green]%}➜ :%{$fg[red]%}➜ )"

PROMPT='%{$fg_bold[cyan]%}%c%{$reset_color%}$(git_prompt_info) $STATUS_ARROW'
RPROMPT='$(aws_prompt_info) $(kube_ps1)'
