## Examples

    google-ssl-cert completion

Prints words for TAB auto-completion.

    google-ssl-cert completion
    google-ssl-cert completion hello
    google-ssl-cert completion hello name

To enable, TAB auto-completion add the following to your profile:

    eval $(google-ssl-cert completion_script)

Auto-completion example usage:

    google-ssl-cert [TAB]
    google-ssl-cert hello [TAB]
    google-ssl-cert hello name [TAB]
    google-ssl-cert hello name --[TAB]
