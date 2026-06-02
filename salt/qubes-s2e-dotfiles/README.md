# QUBES-S2E-DOTFILES

Dotfiles are downloaded from the public repo within a template used by many AppVM's. This reduces updates by only downloading the updates once per template when updates are uploaded to github.

## To Update dotfiles across all templates & AppVms

Update repo from github for all templates
```shell_session
[dom0]$ DOT_TMPLTS="$(qvm-ls --no-spinner --fields NAME,CLASS --tags has-dotfiles | grep TemplateVM | cut -d ' ' -f 1 | tr '\n' ',')" && sudo qubesctl --skip-dom0 --show-output --targets="${DOT_TMPLTS}" state.apply qubes-s2e-dotfiles.install saltenv=user -l debug
```

Update symlinks for all AppVM's (Only needed if new files are added)
```shell_session
[dom0]$ DOT_APPS="$(qvm-ls --no-spinner --fields NAME,CLASS --tags has-dotfiles | grep AppVM | cut -d ' ' -f 1 | tr '\n' ',')" && sudo qubesctl --skip-dom0 --show-output --targets="${DOT_APPS}" state.apply qubes-s2e-dotfiles.install-appvm saltenv=user -l debug
```


# License

Please see the [license file](./LICENSE) for license information. If you have further questions related to licensing PLEASE create an issue about it on github.
