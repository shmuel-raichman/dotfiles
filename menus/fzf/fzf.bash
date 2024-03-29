#!/bin/bash
# B"H
echo "Sourced file: " $(basename "${BASH_SOURCE}")

command -v fd >/dev/null 2>&1 && {
    export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore-vcs --exclude '.git'"
    # export FZF_DEFAULT_COMMAND="exa -a --icons --group-directories-first -R -1 | awk {print $2}"
}

mine()
{
	$(declare -F | awk '{print $3}' | grep --color=never ^[A-Z] | fzf) 
}

##################################################################
################# Example default fzf options ####################
##################################################################
## 
## export FZF_DEFAULT_OPTS="
## --layout=reverse
## --info=inline
## --height=80%
## --multi
## --preview-window=:hidden
## --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
## --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
## --prompt='∼ ' --pointer='▶' --marker='✓'
## --bind '?:toggle-preview'
## --bind 'ctrl-a:select-all'
## --bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
## --bind 'ctrl-e:execute(echo {+} | xargs -o vim)'
## --bind 'ctrl-v:execute(code {+})'
## "
##
## https://github.com/junegunn/fzf/blob/master/ADVANCED.md#color-themes
## Something blue
## --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
## junegunn/seoul256.vim (dark)
## export FZF_DEFAULT_OPTS+='--color=bg+:#3F3F3F,bg:#4B4B4B,border:#6B6B6B,spinner:#98BC99,hl:#719872,fg:#D9D9D9,header:#719872,info:#BDBB72,pointer:#E12672,marker:#E17899,fg+:#D9D9D9,preview-bg:#3F3F3F,prompt:#98BEDE,hl+:#98BC99'
## junegunn/seoul256.vim (light)
## export FZF_DEFAULT_OPTS+='--color=bg+:#D9D9D9,bg:#E1E1E1,border:#C8C8C8,spinner:#719899,hl:#719872,fg:#616161,header:#719872,info:#727100,pointer:#E12672,marker:#E17899,fg+:#616161,preview-bg:#D9D9D9,prompt:#0099BD,hl+:#719899'
## morhetz/gruvbox
## export FZF_DEFAULT_OPTS+='--color=bg+:#3c3836,bg:#32302f,spinner:#fb4934,hl:#928374,fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934,marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934'
## arcticicestudio/nord-vim
## export FZF_DEFAULT_OPTS+='--color=bg+:#3B4252,bg:#2E3440,spinner:#81A1C1,hl:#616E88,fg:#D8DEE9,header:#616E88,info:#81A1C1,pointer:#81A1C1,marker:#81A1C1,fg+:#D8DEE9,prompt:#81A1C1,hl+:#81A1C1'
## tomasr/molokai
## export FZF_DEFAULT_OPTS+='--color=bg+:#293739,bg:#1B1D1E,border:#808080,spinner:#E6DB74,hl:#7E8E91,fg:#F8F8F2,header:#7E8E91,info:#A6E22E,pointer:#A6E22E,marker:#F92672,fg+:#F8F8F2,prompt:#F92672,hl+:#F92672'
##################################################################
##################################################################
##################################################################

export FZF_DEFAULT_OPTS="
--info=inline
--height=100%
--multi
--color='bg+:#3F3F3F,bg:#4B4B4B,border:#6B6B6B,spinner:#98BC99,hl:#719872,fg:#D9D9D9,header:#719872,info:#BDBB72,pointer:#E12672,marker:#E17899,fg+:#D9D9D9,preview-bg:#3F3F3F,prompt:#98BEDE,hl+:#98BC99'
--layout=reverse 
--border 
--margin=1 
--padding=1
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--prompt='∼ ' --pointer='▶' --marker='✓'
--header '╱ CTRL-y (Copy xclip) ╱ CTRL-e (Open in vim) ╱ CTRL-v (Open in VSCode) ╱ Lshift-? (toggle preview) ╱'
--bind '?:change-preview-window(hidden|20%|40%|60%|80%|20%,down|40%,down|60%,down|80%,down|20%,left|40%,left|60%,left|80%,left|20%,right|40%,right|60%,right|80%,right)'
--bind 'ctrl-a:select-all'
--bind 'ctrl-y:execute-silent(echo {+} | xclip -r -sel clip)'
--bind 'ctrl-e:execute(echo {+} | xargs -o vim)'
--bind 'ctrl-v:execute(code {+})'
"

function fzf-eval()
{ 
    echo | fzf -q "$*" --preview-window up,99%,down \
        --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899' \
        --preview="eval {q}"; 
}
