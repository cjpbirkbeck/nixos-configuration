# System-wide configuration for bash.

{ config, pkgs, ... }:

{
  programs = {
    bash = {
      enableCompletion = true;
      shellInit = ''
        export HISTFILE=$HOME/.local/share/bash/history
      '';
      promptInit = ''
        if [ "$TERM" = "dumb" -o -n "$INSIDE_EMACS" ]; then
          PS1="[\w]\$ "
        else
          PS1="\[\033[1;32m\][\u@\h]\[\033[1;34m\][\w]\$\[\033[0m\] "
        fi
      '';
      interactiveShellInit = ''
        stty -ixon    # Disable C-s and C-q in terminals

        # Check window size after each command, redraw need be.
        shopt -s checkwinsize
        # Change directory with directory name only.
        # Check spelling of directories.
        # Check spelling of directories during auto-completion.
        shopt -s autocd cdspell dirspell
        # Allow use of ** pattern, which matches all files and subdirectories.
        shopt -s globstar
        # Append to the history file, not overwrite it.
        shopt -s histappend
        # Lines entered as one unit are written as one unit
        shopt -s cmdhist

        # Do not store commands that start with space.
        # Also ignore duplicate commands.
        HISTCONTROL=ignoreboth

        # Ignore ls and any aliases, bg, fg, history and clear.
        HISTIGNORE='ls:l:lx:la:lz:ll:la:lA:bg:fg:history:clear'

        # Save date in the locales date-time representation.
        HISTTIMEFORMAT='%c '

        # Initialize fasd except for the aliases.
        # eval "$(fasd --init auto)"

        # Store each line in history immediately.
        PROMPT_COMMAND="$PROMPT_COMMAND history -a"

        # Load fzf completions
        source ${pkgs.fzf}/share/fzf/completion.bash

        # Load fzf key bindings
        source ${pkgs.fzf}/share/fzf/key-bindings.bash
      '';
    };
  };
}
