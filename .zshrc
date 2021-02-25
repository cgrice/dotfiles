# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Setup a cache for autocomplete
autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

# Make autocomplete menus work
zmodload -i zsh/complist

HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HISTSIZE

COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell
setopt correct_all # autocorrect commands
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion

# Load antibody plugin manager
source <(antibody init)

# Plugins
antibody bundle zdharma/fast-syntax-highlighting
antibody bundle zsh-users/zsh-autosuggestions

antibody bundle romkatv/powerlevel10k

if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
  iterm2_print_user_vars() {
    iterm2_set_user_var cpuTemp $(osx-cpu-temp)
    iterm2_set_user_var awsProfile "☁ $AWS_PROFILE"
    iterm2_set_user_var kubeContext "⎈ $(kubectx -c)"
  }
  test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH="/usr/local/opt/qt/bin:$PATH"
export PATH=$ANDROID_SDK/platform-tools:$PATH
export PATH="$HOME/.jenv/bin:$PATH"

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

export LUNA_NEXUS_TOKEN=NpmToken.90e7c10d-25ab-3e8a-b54c-893d22b916f2
export NEXUS_TOKEN=NpmToken.90e7c10d-25ab-3e8a-b54c-893d22b916f2

export GOPATH=$HOME
export ANDROID_SDK=/Users/chris.grice/Library/Android/sdk
export AWS_SDK_LOAD_CONFIG=1

# Useful functions
finduser() {
  userinfo=$(dscl localhost read /Search/Users/$1)
  echo "Email:\t\t$(echo $userinfo | grep -a userPrincipalName | sed s/dsAttrTypeNative:userPrincipalName:\ //g)"
  echo "Employee ID:\t$(echo $userinfo | grep -a employeeNumber | sed s/dsAttrTypeNative:employeeNumber:\ //g)"
  echo "Grade:\t\t$(echo $userinfo | grep -a extensionAttribute2 | sed s/dsAttrTypeNative:extensionAttribute2:\ //g)"
  echo "Start Date:\t$(echo $userinfo | grep -a extensionAttribute10 | sed s/dsAttrTypeNative:extensionAttribute10:\ //g)"
  echo "Mac Admin:\t$((echo $userinfo | grep -aq RESMACADMIN01G) && echo yes || echo no)"
  echo "VPN:\t\t$((echo $userinfo | grep -aq ADMRDPCONNECT01_F5_NORMAL) && echo yes || echo no)"
  echo "Blackfriars:\t$((echo $userinfo | grep -aq RESDEVWIRELESSUSER01G) && echo yes || echo no)"
}

eval "$(jenv init -)"
eval "$(direnv hook zsh)"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias dps="docker ps"
