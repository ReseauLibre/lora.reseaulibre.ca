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

| Name                  | Hex Key                            | Base64                     | Purpose                                                          |
|-----------------------|------------------------------------|----------------------------|------------------------------------------------------------------|
| Public                | `8b3387e9c5cdea6ac9e5edbaa115cd72` | `izOH6cXN6mrJ5e26oRXNcg==` | General conversations                                            |
| `#911`                | `907a3dd4b73b9d1324b4d6c83425c186` | `kHo91Lc7nRMktNbINCXBhg==` | Emergency communications (french)                                |
| `#emergency`          | `e1ad578d25108e344808f30dfdaaf926` | `4a1XjSUQjjRICPMN/ar5Jg==` | Emergency communications (English)                               |
| `#meshcore-ops`       | `dd95f5167774c3967edee5c606bcad43` | `3ZX1Fnd0w5Z+3uXGBrytQw==` | Operator coordination                                            |
| `#montreal`           | `0c4c03b5fbea5b80f89e2a2a16ed3f40` | `DEwDtfvqW4D4nioqFu0/QA==` | Montreal-specific traffic, see also `#ottawa`                    |
| `#wardriving`         | `e3c26491e9cd321e3a6be50d57d54acf` | `48JkkenNMh46a+UNV9VKzw==` | Used by [Meshmapper][] pings                                     |
| `#habs`               | `e570409412b40c123b4ab787351ab30b` | `5XBAlBK0DBI7SreHNRqzCw==` | Far from real time game updates and gossip                       |
| `#bots`               | `0d24f5830b449668b8c221759b6c50d2` | `DST1gwtElmi4wiF1m2xQ0g==` | Where to run bots, a bot replies to `test` and `ping`there       |
| `#betabots`           | `964072df07723403a611c5cec6d6db95` | `lkBy3wdyNAOmEcXOxtbblQ==` | Run bots here before joining `#bots`, to test                    |
| `#test`               | `9cd8fcf22a47333b591d96a2b848b73f` | `nNj88ipHMztZHZaiuEi3Pw==` | A message that just says `test`? send it here or `#testing`      |
| `#devtest`            | `0fd265aa14c00829af942771c742176e` | `D9JlqhTACCmvlCdxx0IXbg==` | To test messages while developing, do *not* answer messages here |
| `#ceuxquimarchemoyen` | `751be125eb7d167e07a95603c9e9a5dd` | `dRvhJet9Fn4HqVYDyeml3Q==` | Another test channel for people who have trouble                 |

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

