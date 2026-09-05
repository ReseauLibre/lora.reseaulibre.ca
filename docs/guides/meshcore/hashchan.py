#!/usr/bin/python

import base64
import hashlib
import sys


def compute_mc_hash(name: str) -> bytes:
    """compute the hash of a MeshCore channel

    A meshcore channel hash is based on the SHA256 checksum digest of
    the UTF-8 encoded byte string of the channel name, truncated to 16
    characters."""
    return hashlib.sha256(name.encode("utf-8")).digest()[:16]


def main():
    if len(sys.argv) <= 1:
        exit("usage: %s [ CHANNEL_NAME ... ]" % sys.argv[0])

    print("| Name | Purpose | Hexadecimal secret key | Base64 secret key |")
    print("| ---- | ------- | ---------------------- | ----------------- |")
    for name in sys.argv[1:]:
        binary = compute_mc_hash(name)
        print(f"| `{name}` | | `{binary.hex()}` | `{base64.b64encode(binary).decode("ascii")}` |")


if __name__ == "__main__":
    main()
