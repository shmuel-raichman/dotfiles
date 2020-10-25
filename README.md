B"H

I use it to collect all my dotfiles (.bash..., .vimrc, etc..) So whenever i use new computer or vm on regular base i just lone it to ~ source it and here i have my custom shell

# Run the command below ~/.bashrc or ~/.bash_profile or both if you not sure.
cat dotfiles/add_to_dot_bash >> .bashrc

Kubernetes Prompt (PS1) Can be enabled and disabled by running the commands
```
# To Disable the kubernetes prompt.
disable_k8s_ps1
# To Enable the kubernetes prompt.
enable_k8s_ps1
```