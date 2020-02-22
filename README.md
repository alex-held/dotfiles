# dotfiles
My dotfiles used for syncing and bootstrapping new systems

# Installing on macOS

``` bash

bash -c "$(curl -fsSL https://raw.githubusercontent.com/alex-held/dotfiles/master/configure.sh)"

```

# Secret Encryption

Githooks make sure that your *.secret files are encrypted
 
Encrypts a secret file using my gpg userid.
gp-lock <secret-file>

Decrypts a secret file using my gpg userid.
gp-unlock <encrypted-secret-file> <decrypted-file>