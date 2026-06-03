# QUBES-S2E-DESK

## Troubleshooting

### Wipe all qubes installed by default

You need to run the command in a specific order to not get conflicts

```
VER=$(qubesctl pillar.get os:template:base_version:debian --out=txt | awk '{print $NF}')
qvm-remove -f studio
qvm-remove -f personal-desk
qvm-remove -f work-desk
qvm-remove -f tpl-studio-${VER}
qvm-remove -f tpl-wkspc-${VER}
qvm-remove -f tpl-desk-${VER}
qvm-remove -f tpl-base-${VER}
```

### Reinstall template Qubes w/o deleting AppVM's


```
######
# Shut down AppVM `qvm-shutdown <AppVM>`
# Change template to standard `qvm-prefs <AppVM> template debian-12`
######
# Studio
qvm-shutdown studio
qvm-prefs studio template debian-12
# Personal-Desk
qvm-shutdown personal-desk
qvm-prefs personal-desk template debian-12
# Work-Desk
qvm-shutdown work-desk
qvm-prefs work-desk template debian-12

qvm-remove -f tpl-studio-12
qvm-remove -f tpl-wkspc-12
qvm-remove -f tpl-desk-12
qvm-remove -f tpl-base-12

sudo dnf install /tmp/qubes-s2e-desk-0.0.1-1.fc41.noarch.rpm

qvm-prefs studio template tpl-studio-12
qvm-prefs personal-desk template tpl-wkspc-12
qvm-prefs work-desk template tpl-wkspc-12
```


# License

Please see the [license file](./LICENSE) for license information. If you have further questions related to licensing PLEASE create an issue about it on github.
