# Transport nodes and microReticulum

All of the above is about "clients", in the sense that most of the
software is geared towards new users, and rightly so.

But we did not talk much about routing, which is a core tenant of mesh
networks of course. That's because there is a separate feature to
enable on a RNode to enable that, it's called a "transport".

Because the devices we have setup, so far, all require a client like a
computer, it makes this all inconvenient to host on your rooftop.

Thankfully people figured out a solution to this problem and starting
expanding RNode to support routing, into something called an RTNode,
for "Reticulum Transport Node".

Cleeyv wrote an [excellent guide on how to setup the RTNode
firmware](https://rns.recipes/forum/build-guides/how-to-install-and-test-the-rtnode-firmware), which we'll defer to.

Our only addition is that we had to put the device in upload mode, by
holding the "BOOT" (actually labeled `PGR` on the board) button while
pressing "RESET" (`RST`), before running the `flash.py` command.

See also this [untested Ethernet gateway firmware](https://rns.recipes/forum/showcase/rnode-over-ethernet-rak4631-rak13800-ethernet-module).
