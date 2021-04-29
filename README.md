B"H

I use it to collect all my dotfiles (.bash..., .vimrc, etc..) <br>
So whenever i use new computer or vm on regular base i just clone it to $HOME, source it and here i have my custom shell

# PS1 Demo
[![asciicast](https://asciinema.org/a/elYkkn1lMWlrLpmvFE20YL5AT.svg)](https://asciinema.org/a/elYkkn1lMWlrLpmvFE20YL5AT)
![example gif](https://drive.google.com/file/d/1hwZ5TtUBs4zCtYCxxEiOTtpPqUv-GpIU/view?usp=sharing)

# Install
## Run the command below ~/.bashrc or ~/.bash_profile or both if you not sure.
cat dotfiles/add_to_dot_bash >> .bashrc

# Kuberentes PS1
Kubernetes Prompt (PS1) Can be enabled and disabled by running the commands
```
# To Disable the kubernetes prompt.
disable_k8s_ps1
# To Enable the kubernetes prompt.
enable_k8s_ps1
```
