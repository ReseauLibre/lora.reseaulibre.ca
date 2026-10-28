# Channel configuration

If you want to go a little further, you should know that MeshCore
supports the concept of "channels" which are essentially different
communities separated by their own private keys.

Many of those are "public", in the sense that the encryption key is
derived from an easy to guess name, like `#testing`, so those are not
"really" encrypted.

But you can use channels to really create your own secret
communication channels. Contents will be encrypted as long as the
channel name remains secret, but who is talking to who, the number of
messages sent will be visible to an attacker.

## Public channels

We know about the follow channels currently in use[^1]:

| Name                  | Purpose                                                          | Hexadecimal secret key             | Base64 secret key          |
|-----------------------|------------------------------------------------------------------|------------------------------------|----------------------------|
| Public                | General conversations                                            | `8b3387e9c5cdea6ac9e5edbaa115cd72` | `izOH6cXN6mrJ5e26oRXNcg==` |
| `#911`                | Emergency communications (french)                                | `907a3dd4b73b9d1324b4d6c83425c186` | `kHo91Lc7nRMktNbINCXBhg==` |
| `#emergency`          | Emergency communications (English)                               | `e1ad578d25108e344808f30dfdaaf926` | `4a1XjSUQjjRICPMN/ar5Jg==` |
| `#operators`          | Operator coordination, previously `#meshcore-ops`                | `1d2c8ee2ee25af1c7a25f6eb6fbbf020` | `HSyO4u4lrxx6Jfbrb7vwIA==` |
| `#montreal`           | Montreal-specific traffic, see also `#ottawa`                    | `0c4c03b5fbea5b80f89e2a2a16ed3f40` | `DEwDtfvqW4D4nioqFu0/QA==` |
| `#wardriving`         | Used by [Meshmapper][] pings                                     | `e3c26491e9cd321e3a6be50d57d54acf` | `48JkkenNMh46a+UNV9VKzw==` |
| `#habs`               | Far from real time game updates and gossip                       | `e570409412b40c123b4ab787351ab30b` | `5XBAlBK0DBI7SreHNRqzCw==` |
| `#bots`               | Where to run bots, a bot replies to `test` and `ping`there       | `0d24f5830b449668b8c221759b6c50d2` | `DST1gwtElmi4wiF1m2xQ0g==` |
| `#betabots`           | Run bots here before joining `#bots`, to test                    | `964072df07723403a611c5cec6d6db95` | `lkBy3wdyNAOmEcXOxtbblQ==` |
| `#testing`            | A message that just says `test`? send it here or `#test`         | `cde5e82cf515647dcb547a79a4f065d1` | `zeXoLPUVZH3LVHp5pPBl0Q==` |
| `#devtest`            | To test messages while developing, do *not* answer messages here | `0fd265aa14c00829af942771c742176e` | `D9JlqhTACCmvlCdxx0IXbg==` |
| `#ceuxquimarchemoyen` | Another test channel for people who have trouble                 | `751be125eb7d167e07a95603c9e9a5dd` | `dRvhJet9Fn4HqVYDyeml3Q==` |

 [Meshmapper]: https://meshmapper.net/

You should generally not need the hex and Base64 keys. They are only
provided here as a reference for some rate situations where you need
to enter the secret key directly. For example, some standalone
firmware like the T-Deck might require this although you might get
away with popping up the menu to select the <kbd>Enter</kbd> <kbd>#</kbd> option.

[^1]:
    Those hashes were generated with the one-liner:
    
        python -c 'import base64; import hashlib; import sys; bytes = hashlib.sha256(sys.argv[1].encode("utf-8")).digest()[:16]; print(bytes.hex(), base64.b64encode(bytes).decode("utf-8"))' '#testing'

    A more readable version is available as [hashchan.py](hashchan.py).

## Other channels

See also the channels used in other communities:

- [Ottawa mesh](https://ottawamesh.ca/fr/meshcore/general-public-channels/)
- [Puget mesh](https://pugetmesh.org/meshcore/)
- [Switzerland](https://www.meshcore.ch/channels/)

## Private channels

All the above channels are, obviously, not really secret. First, they
are documented here publicly, but also their private key is derived
from the name of the channel which is a single, easy to guess word.

Those spaces are not for private conversations! It's possible to have
more private channels by creating a new channel with randomly
generated key. The way to do this will vary according to the client,
but generally, you absolutely want to let the software generate the
key automatically, and *not* make one yourself, as otherwise you are
likely going to create an easily guessable key.

Then your next problem is to share the key across devices. If you use
a phone app, you can share the key by scanning it with a bar code on
some software. Otherwise you will need to copy the hexadecimal key
between devices.

You *may* send the key over a direct message. This has the important
vulnerability that someone may "machine-in-the-middle" attack your
connection and learn the key. But if you are in an isolated area, it
can work relatively securely.
