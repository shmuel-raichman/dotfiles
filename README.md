B"H

I use it to collect all my dotfiles, mostly bash aliases and functions i'm using frequently (kubectl, git, etc..) <br>
So whenever i use new computer or vm on regular base i just clone it to $HOME, source it and here i have my custom shell

# PS1 Demo
<!-- [![asciicast](https://asciinema.org/a/elYkkn1lMWlrLpmvFE20YL5AT.svg)](https://asciinema.org/a/elYkkn1lMWlrLpmvFE20YL5AT) -->
![](https://github.com/smuel1414/dotfiles/blob/files/demo/dotfile-02.gif)

[asciinema](https://asciinema.org/a/elYkkn1lMWlrLpmvFE20YL5AT) Here you can copy the commands shown in the gif

# Install
## Run the command below: 
```
cat dotfiles/add_to_dot_bash >> .bashrc
```
Change to `~/.bashrc` or `~/.bash_profile`, if you not sure do the same for both.
# Kuberentes PS1
Kubernetes Prompt (PS1) Can be enabled and disabled by running the commands
```
# To Disable the kubernetes prompt.
disable_k8s_ps1
# To Enable the kubernetes prompt.
enable_k8s_ps1
```
