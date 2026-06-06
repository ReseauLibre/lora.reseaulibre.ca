# Chat with LXMF-CLI

Since a [basic RNS setup](rns.md) does not do much on its own, we
will introduce you to a first basic chat application.

If you are familiar with the command-line, [LXMF-CLI](https://github.com/fr33n0w/lxmf-cli) is a nice and
simple chat client. It does not have a great installer (see [upstream
issue 4](https://github.com/fr33n0w/lxmf-cli/issues/4), so we have to wrangle things out a little bit. Here we
assume we can reuse the Python `venv` used to [install RNS](rns.md#installation-and-configuration):

```
git clone https://github.com/fr33n0w/lxmf-cli
~/.venvs/reticulum/bin/pip install -r requirements.txt
ln -s $PWD/lxmf-cli.py ~/.venvs/reticulum/bin/lxmf-cli.py
cat > ~/.venvs/reticulum/bin/lxmf-cli <<EOF
#! /bin/sh
 
mkdir -p .config/lxmf-cli
cd .config/lxmf-cli
python ~/.venvs/reticulum/bin/lxmf-cli.py
EOF
chmod +x ~/.venvs/reticulum/bin/lxmf-cli
```

The wrapper script is necessary because [LXMF-CLI does not write files
in the right place](https://github.com/fr33n0w/lxmf-cli/issues/5).

Then you can start the client with:

    lxmf-cli

When starting, it will prompt you for your identity and some settings,
then it will announce your identity on the network through `rnsd`.

If other identities are found through announces, it will notify you
and you will be able to add them as contacts. For example:

```
📡 New Announce: newfriend
🔗 <a18d35e7e283b3e95158c5412ac58b4c>
💡 Quick save: 'ap 1' | Send: 'sp 1 <msg>'
> ap 1
✓ Contacts saved
✓ Added contact: newfriend
  Display name: My New Friend
> sp 1 found you!
Sending to peer #1: My New Friend
📤 Sending to: My New Friend...

✅ Delivered to My New Friend (0.5s)
```

The interface is otherwise pretty intuitive, use `h` or `help` for
usage. A few useful commands:

- `ann` or `announce`: announce your presence on the mesh, required
  for others to message you, if you are new or changed place
- `p` or `peers`: show the currently visible peers
- `c` or `contacts`: show contact list
- `s` or `send`: send a message to a user
- `reply` or `re`: reply to a user that just came in

LXMF-CLI also has a [surprisingly large collection of plugins](https://github.com/fr33n0w/lxmf-cli/tree/main/plugins)
doing anything from a simple echo bot, logging, weather, but also a
Telegram bridge and more.

One plugin that's useful to enable is the [`prop_nodes` plugin](https://github.com/fr33n0w/lxmf-cli/blob/9ca50d00f67443e349346c7d9696e77b3a39abd3/plugins/prop_nodes.py#L494), as
it will enable the use of [propagation nodes](https://reticulum.miraheze.org/wiki/Propagation_node) which can store
messages for later replay if a contact is not online.

A simple way is to just make all plugins available with:

    ln -s ~/Projects/src/lxmf-cli/plugins ~/.config/lxmf-cli/lxmf_client_storage/plugins

Then restart `lxmf-cli`, and run:

    plugin enable prop_nodes
    plugin reload
    prop on

Then `lxmf-cli` will try to discover a propagation node. If that never
finishes, you can try to add a known propagation node with:

    prop set a4746deea5c67422f12a621fe6d4ccc8

The above is a random string that is not an actual propagation
node. You'll need to find your own propagation node, and it's unclear
how exactly we're supposed to find those.
