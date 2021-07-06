# Mail

This ansible role installs and configures a mailing system and client relaying to an SMTP server (Gmail).

## Requisites

The following environment variables must be present:

- **DOTFILES_HOST_NAME**: host name, mailname configured for postfix will be <hostname>.localdomain
- **DOTFILES_USER_NAME_FULL**: Full name of the user mail is relayed for
- **DOTFILES_USER_EMAIL**: email address to use for the relay
- **DOTFILES_SMTP_RELAY_HOST**: relay host to use
- **DOTFILES_SMTP_APP_KEY**: Gmail app key

To fulfill these requisites, you will probably need to add the following to your `.envrc` file:

```sh
export DOTFILES_SMTP_APP_KEY="<Gmail SMTP app authorization key>"
export DOTFILES_SMTP_RELAY_HOST="<SMTP relay host (ie: [smtp.gmail.com]:587)>"
```

## Usage

Try if you can send emails:

```sh
echo "Hello world, it's dotfiles sending emails!" | mail -s "[SMTP proxy] Hello World" <yourtest@email.adress>
```

## TO-DO

- Properly configure Mutt