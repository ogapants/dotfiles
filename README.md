# Before
Please install [prezto](https://github.com/sorin-ionescu/prezto) & [prezto-prompt-simple](https://github.com/kami-zh/prezto-prompt-simple) before setting up.
```
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
```

```
curl https://raw.githubusercontent.com/kami-zh/prezto-prompt-simple/master/prompt_simple_setup > ~/.zprezto/modules/prompt/functions/prompt_simple_setup
```

# Execute setup.sh
Generate symbolic links to required directories.
```
git clone https://github.com/NTSK/dotfiles.git
chmod +x dotfiles/setup.sh
dotfiles/setup.sh
```

# Other
iTerm2 color scheme
https://github.com/mbadolato/iTerm2-Color-Schemes/blob/master/schemes/Molokai.itermcolors

Powerline fonts
https://github.com/powerline/fonts
https://github.com/supermarin/powerline-fonts

# Uninstall Prezto
If you want to uninstall prezto, please remove dotfiles.
```
rm -rf ~/.zprezto ~/.zlogin ~/.zlogout ~/.zpreztorc ~/.zprofile ~/.zshenv ~/.zshrc
```
