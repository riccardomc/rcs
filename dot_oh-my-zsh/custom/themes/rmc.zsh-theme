PROMPT=$'🦊 %{$fg[blue]%}%~ $(git_prompt_info)%{$fg[yellow]%} %(1j.🔧%j.)%{$reset_color%}%{$fg[yellow]%} $(aws_prompt_info) %{$reset_color%}\
%#%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="🔥"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_AWS_PREFIX="☁️  "
ZSH_THEME_AWS_SUFFIX=" "
