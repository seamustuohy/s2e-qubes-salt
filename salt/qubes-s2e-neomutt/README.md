# qubes-s2e-email

Formula to create a neomutt email qube that use leer to fetch email from gmail.

Also creates a cold-storage qube for removing emails from gmail once they are no longer needed in the cloud.

# First boot formula
FIRST BOOT PROTOCOL

Private Configs
- Copy your .mutt and .afew  config files over from private configs.
- Copy your emacs message-mode snippets over from private configs.


Setup lieer in SEPARATE browser connected system then copy over ~/mail directory
 - create app
 - get client_secret.json
 - \$ mkdir ~/mail
 - \$ mv client_secret.json ~/mail/.
 - \$ cd ~/mail/
 - \$ notmuch new
 - \$ gmi init -c client_secret.json email@email.com
 - \$ gmi pull
 - Once it fails... resume
 - \$ gmi pull --resume

import or create blank blocked list:
 - \$ touch /home/user/.config/afew/blocked.lsv

import or create blank contacts list:
 - \$ touch /home/user/.contacts.org

run a test afew to check config
 - \$ afew  -vv --tag --new --dry-run

# License

Please see the [license file](./LICENSE) for license information. If you have further questions related to licensing PLEASE create an issue about it on github.
