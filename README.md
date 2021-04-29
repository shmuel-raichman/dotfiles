B"H

I use it to collect all my dotfiles (.bash..., .vimrc, etc..) <br>
So whenever i use new computer or vm on regular base i just clone it to $HOME, source it and here i have my custom shell

# PS1 Demo
[![asciicast](https://asciinema.org/a/elYkkn1lMWlrLpmvFE20YL5AT.svg)](https://asciinema.org/a/elYkkn1lMWlrLpmvFE20YL5AT)
![example gif](https://doc-08-1g-docs.googleusercontent.com/docs/securesc/k9m49sgaqs56ndcihnhab62r8gsmf832/ec2u3lbcdc72d03c7utr3kmqlrcsd0vu/1619736375000/15962894702447426441/12524968753215170543Z/1hwZ5TtUBs4zCtYCxxEiOTtpPqUv-GpIU?e=download&nonce=utr3aits5hi2e&user=12524968753215170543Z&hash=ndej8psa0o6es3q5n1r7ph5dd4c7qn1d)

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
