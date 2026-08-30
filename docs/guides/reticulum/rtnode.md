# Transport nodes

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

What follows is our copy of Cleeyv's [excellent guide on how to setup
the RTNode firmware](https://rns.recipes/forum/build-guides/how-to-install-and-test-the-rtnode-firmware), which we copy here for redundancy but also to
allow us to maintain it collaboratively.

This is a guide for setting up and using the microReticulum-based [RTNode firmware](https://github.com/jrl290/RTNode-HeltecV4) on HeltecV4.2 LoRa hardware, based on testing by [anarchists in Montreal](https://radar.squat.net/en/event/amsterdam/lag/2026-05-08/reticulum-community-videocall-no4-may) in March and April 2026. Due to the 10,000 character limit for posts on the rns.recipes forum, this guide has been split over multiple posts in this thread.

## Context

### Social Context

I wrote this guide because I think Reticulum mesh networks, especially over LoRa and other digital radio connections, have the potential to provide an important option for autonomous communications infrastructure. Until now, the deployment of this infrastructure for Reticulum required a full computer on each node and was therefore more expensive and technically involved than other platforms such as Meshtastic or Meshcore which can run full mesh nodes on smaller, cheaper, more energy efficient microcontroller-based LoRa hardware like ESP32 or nRF52 boards. However, in many ways these other platforms are both less private and less secure than Reticulum. The tests described in this guide demonstrate how it is now possible to run a Reticulum mesh node on ESP32 hardware, making the deployment of Reticulum networks over LoRa much more feasible than it was before.

### Technical context
The original, and still most widely used, version of the [Reticulum Network Stack](https://github.com/markqvist/Reticulum/) (RNS) is written by markqvist in the python programming language. This means that it can only run on regular computers, not on a microcontroller like the ESP32s and nRF52s that run on cheap LoRa nodes. Up until now, when people have been running Reticulum over LoRa, the regular RNode (notice there's no T for transport) firmware they flash to a LoRa node doesn't actually run Reticulum/RNS. It plugs into another device like an Android phone, laptop, RPi or other computer that is running RNS, and provides a LoRa radio interface that RNS can then be configured to use. This is fine until you want to deploy an autonomous node running on solar and batteries, and then the requirement to maintain a full computer that can run python implies significant infrastructural overhead: more electricity, a bigger solar panel, higher voltage, more batteries, more complex electronics, higher cost, etc. 

The solution to this problem lies in new versions of the Reticulum software written in more hardware-efficient languages that can run on microcontrollers. The most usable of these so far is called [microReticulum](https://github.com/attermann/microReticulum), written in C++ (the same language as the Meshtastic and Meshcore firmwares). There are also a few other Reticulum versions being written in Rust that may eventually become usable in microcontroller firmware, but for now there's just microReticulum. The core microReticulum software is a C++ library that isn't very useful on its own. It needs to be imported into separate software that is used to build firmware images that can then be flashed to LoRa hardware.

The developer of microReticulum (attermann) has separate project called [microReticulum_firmware](https://github.com/attermann/microReticulum_Firmware/) that builds and releases microReticulum-based firmware images for many common LoRa boards, but it has been unclear to me how much testing is happening to confirm how well each image actually works. Both the library and the firmware continue to be under heavy development, and their documentation is relatively limited. When I have tried a couple times to test them they haven't seemed to work. This testing should continue though, especially for nRF52-based boards such as the RAK4631/Wisblocks that that use even less power than the Heltecs and other ESP32s. 

Our current round of testing in Montreal started in late-February 2026 after the publication on February 22nd of the [RTNode-HeltecV4](https://github.com/jrl290/RTNode-HeltecV4) repository. This project took the microReticulum library and did the work required to create an actually usable, relatively well-documented firmware for the new HeltecV4 hardware which had become available for purchase a few months earlier in Fall 2025. As far as I am aware, this is the first reliably usable microReticulum firmware for a LoRa transport node, and this guide explains how you can use it.

The RTNode project was created to run on the original model of the HeltecV4 hardware, which is version 4.2 of the board. However, soon after first release there were problems discovered with the radio reception levels of the board and so a new version 4.3 was more recently released to fix this problem. Just days prior to the publication of this guide, the RTNode firmware was updated for compatibility with the v4.3 boards, and this still needs to be tested. Whichever HeltecV4 hardware you end up with, there should soon be a way to get it working as a microReticulum-based transport RNode. If you have a choice, it is probably better to purchase HeltecV4.3 boards because they have improved LoRa reception.  

Since its start on the HeltecV4.2, the RTNode project has also added support for the older HeltecV3 and now other people are making [forks](https://github.com/GrayHatGuy/RTNode-HeltecV4) of the repository adding support for other ESP32-based hardware. It is also worth noting that the developer of the RTNode firmware (jrl290) had never previously worked on firmware and they were only able to do this work with substantial involvement of an LLM in the development process.

## Installation
### Flashing RTNode
This flashing process, as well as the rest of the configuration and testing, was all done on version 1.0.24 of the project from late-March 2026. As of May 2nd, 2026, it is now on version 1.0.30 and a number of substantial improvements have been recently introduced, including an [RTNode Firmware Flasher website](https://jrl290.github.io/RTNode-HeltecV4/). However, we haven't tested these changes yet so I'm mostly going to keep the guide as it was originally written for an earlier version. I would recommend using the latest version of RTNode despite some differences from the instructions in this guide. 

The flashing process requires having git and python installed on your computer. The later testing steps will require the [tio](https://github.com/tio/tio) serial tool, and it might be simpler to install that as well before you start. These instructions should work on any Linux-based OS.

First, plug in your HeltecV4 with a USB cable.

In a terminal:

```
ls -d /dev/* | grep ttyACM
```

The line that is output is the path (probably /dev/ACM0) to the serial port for your Heltec and you will use this path in the flash.py command below. For different models, such as a HeltecV3, this serial path could have a different format.

Also, as your device gets unplugged and plugged back in, and reset multiple times, the port number can increment, for example from /dev/ttyACM0 to /dev/ttyACM1 and so on. Whenever doing something that involves connecting over a serial device it is worth doing the terminal command above to see which port number is currently in use. 

Also note that your linux user may need to be in the dialout group to be able to connect to this port properly. You can run the groups command to check if your user is already in dialout and if not this command will add it:

```
sudo usermod -aG dialout $USER
```

It may then be necessary to start a new shell or system session for this change to come into effect. 

These three terminal commands will download the RTNode firmware code:

```
cd /to_the_directory_where/you_want_to_put_the_repo/for_this_project/
git clone https://github.com/jrl290/RTNode-HeltecV4.git
cd RTNode-HeltecV4
```

Then in a browser:

Go to the [RTNode-HeltecV4 releases page](https://github.com/jrl290/RTNode-HeltecV4/releases/latest) and download the rnode_firmware_heltec32v4_boundary.bin file (renamed in later versions) into the git repo directory you created above.

Back to the same terminal session as above:

```
python flash.py --board v4 --file rnode_firmware_heltec32v4_boundary.bin --port /dev/ttyACM0
```

When I did the flash I was asked three prompts, confirming that I want to wipe and reflash the node, and I said yes to all of them.

### Configuring RTNode

When the flash completes the board will reboot into config mode. You can tell because it says "CONFIG MODE" on the screen. It also tells you the name of the WiFi SSID it is broadcasting, RNode-Boundary-Setup.

Connect to this WiFi network, and then in a browser go to [http://10.0.0.1/](http://10.0.0.1/) for the config page for the node.

For LoRa-only use you want to set the WiFi Network to "Disabled (LoRa-only Repeater)". The RTNode firmware also has support for acting as a Reticulum node over the internet or a local WiFi network, but those use cases are not covered in this guide. 

The only remaining setup required is the LoRa Radio settings. These need to match the settings on the other RNodes you will be using on your LoRa network. Make sure you use a frequency that is not being used by other nearby RNodes that are not part of your testing, as this could cause complications later. We haven't tested the IFAC settings yet on RTNodes, but we plan to!

When you're done configuring, you would usually click Save & Reboot at the bottom and the node would reboot into regular mode and be ready to use, but we're not going to do that yet. Instead, before clicking this button, we will prep for testing.

## Testing
### Understanding RTNode
As mentioned at the beginning, the testing requires a serial device reader. The one I use is tio but there are others.

In a terminal, using the serial path for you device (it should still be the same as above in the flashing but it is worth confirming first because it can change):

```
tio /dev/ttyACM0 -b 115200 -e -t | awk '{print $0"\r"}'
```

You should see output like this:

```
[...] tio 3.9
[...] Press ctrl-t q to quit
[...] Connected to /dev/ttyACM0
```

And then below this it will show the serial output log of what's happening on the RTNode. There may be nothing at first. To get the most useful information, you want to be connected during a boot of the node. So now back on the RNode-Boundary-Setup, in the browser at [http://10.0.0.1/](http://10.0.0.1/) click the Save & Reboot button to reboot into regular mode. 

When it reboots it will be in regular mode, and you should see on the screen the LoRa radio configs you just entered, that only LoRa is enabled, and the Air % indicates levels of LoRa activity on the air in the configured frequency/parameters. As it boots, you should see a bunch of output from tio. The two lines that are most relevant for this testing look like this:

```
[...] ... [NOT] Transport Instance will respond to probe requests on {Destination:********************************}
[...] ... [VRB] Transport instance {Identity:********************************}
```

The "..." have time and date information and the ****** are filling in for 32 character random hashes that are cryptographically unique to this node and used to identify it and communicate with it. Save these two lines so that the hashes can be referred back to later in the test. Then make sure to close the tio session by typing ctrl-t and then q because leaving it open can cause problems later.

The "top" and "bottom" button names used here is for when the board is oriented so that the buttons are on the left hand side. Other than the "Save & Reboot" button in the web interface, the other option for getting the device to boot is clicking the bottom button. Here is more info on what I've figured out about how the buttons work:

- Clicking the bottom button once should (re)boot the device into regular mode, including when it is off.
- Holding the top button for 5 seconds should reboot the device into config mode if it is already turned on.
- Clicking both buttons at the same time should turn the device off.

I say "should" because it seems finicky and this is only based on my limited trial and error and I haven't found documentation for this.

### Requirements for Tests
The first test is relatively simple and confirms that the node is able to communicate over LoRa. It will require one additional RNode besides the HeltecV4 RTNode you've already flashed. You can use it with the same computer that you've been using for flashing. It will need the RNS python package to be installed (specifically for the rnprobe tool) as well as a running instance of Reticulum (RNS) with an interface config for your RNode. For this I have used MeshChat so that's what I'll describe here but you can also run rnsd, nomadnet, or something else.

The second test is more complex and confirms that the node is actually working as a Reticulum transport node over LoRa. It will require a second regular RNode, connected to a second device running Reticulum. Since this second device needs to be somewhat on the move, I found it was easier for it to be an Android device (in which case you probably need a USB-C to USB-C cable), which could run Reticulum using either [Sideband](https://github.com/markqvist/Sideband) or [Columba](https://github.com/torlando-tech/columba). Columba is what I was using for this test, so that's what I will use in the guide. Sideband and Columba both have pros and cons and it is worth trying out both. If you are using RNode hardware without a screen, and you want to be able to use an initial USB connection to establish bluetooth pairing for wireless use, currently this seems to only be possible with Columba. 

For both the cable connecting the RNode to the computer (either USB-C or USB-A on the computer side) and the cable connecting the other RNode to an Android device (USB-C on both sides), you need to be sure to be using cables that can reliably carry data. Some cables are power only and won't carry data very well or at all, and these could cause problems with your tests.

### LoRa Test
#### RNode on MeshChat

For the simple test you can use the same computer you used for flashing the RTNode. To flash your regular node you can plug whichever RNode-compatible board into the computer with a USB cable and then run either `rnodeconf --autoinstall` (if you have RNS installed) or visit the [RNode Flasher](https://liamcottle.github.io/rnode-flasher/) site on a chromium-based browser (because support for WebSerial is required) and follow the instructions. Columba can also be used to flash an RNode.

During this test I used the original [MeshChat](https://github.com/liamcottle/reticulum-meshchat#download) so that is what I will cover in the guide. However, I have since learned that there is a fork called [MeshChatX](https://meshchatx.com/download.html) that has many new features added and is better kept up to date with new releases of Reticulum. I suspect this is why in late April, the README file of the main Reticulum/RNS repo was updated to switch from a recommendation of MeshChat to one of MeshChatX. 

Once your RNode is flashed, open MeshChat and go to Interfaces page and choose Add Interface, and then the Type "RNode Interface". There is then a Port dropdown to select the serial device for your RNode, as well as the fields to set the same LoRa radio parameters you had configured on the RTNode. Then click "Add Interface" at the bottom, and then the "Restart Now" button and when you get back to the Interfaces list you should see the new RNode one is "Connected". If it does not connect, make sure you didn't leave tio open, it will connect to the serial device for the RNode and block MeshChat.

Now click the "Announce Now" button and you should see the TX Bytes count for the interface increase from sending your announce. If there is an activity indicator LED visible on your RNode you should also see it blink.

#### Rnprobe over LoRa

The final step of the test is to run the following command to confirm a Reticulum connection over LoRa between RNS on your computer with an RNode interface to the RTNode and back:

```
rnprobe rnstransport.probe ****Destination hash from the tio output above****
```

The positive result should say Valid Reply and then info on the LoRa connection, like this:

```
Round-trip time is 877.41 milliseconds over 1 hop [RSSI -46 dBm] [SNR 10.25 dB] [Link Quality 100.0%]
```

### Transport Test

For this test, the computer setup with MeshChat and the RNode interface can stay the same. A second RNode needs to be flashed and then configured with a second device. I find that text is an awkward medium for describing navigation of a touch screen interface. Also, Columba is currently under very active development so there is a higher chance the interface will have changed from what I attempt to describe below. I still hope the below instructions for use of Columba will at least be somewhat helpful when you have the app open in front of you. 

#### RNode on Columba

If you're using an Android device with Columba, when the USB connection between the RNode and your phone is established you will receive an Android popup asking you if you want to open Columba to handle the device.  You need to be sure to select "OK" for this prompt. Depending on your Android settings there may also be a permission request that needs to be approved. Columba may then open in a USB page for your RNode and you can select "Configure RNode" and then jump to the next paragraph of this guide. If the automatic USB config popup didn't appear you can open Columba, go to Settings (bottom right), Network, Manage Interfaces. Then click the plus button in the bottom right, choose RNode LoRa.

In addition to the default USB connection, you can also choose Bluetooth at the top you can try the "Pair via USB" option and if that works then once everything is setup you should be able to detach the USB cable. Once you've chosen the connection to the RNode, either through USB or pairing over Bluetooth, then choose Next in the bottom right and follow the steps. If the options presented in the setup steps don't match exactly what you set on the other nodes you want to communicate with, choose the closest you can and then at the end choose "Advanced Settings" at the bottom to make adjustments. Then touch Save in the bottom right, and then Apply Changes at the top.

Now when you open your RNode interface, under Status it should say "Online" and under Traffic Statistics you can note the amount of data transmitted so far. If you're connected over Bluetooth you'll also see a negative RSSI value. This the strength of the bluetooth connection (as it gets close to -100 it will become unusable). Now go back twice to Settings, choose View Network Status, scroll down and choose Send Test Announce. When it is sent, choose the RNode Interface above and you should see that the data transmitted has increased.

You can also try sending another announce from MeshChat. If your LoRa parameters are correct on both sides then you should be able to see each other's announces and send messages back and forth now. Announces on MeshChat are an option you will see after clicking "Messages" at the top of the left hand menu. In Columba they can be seen by going to Contacts in the bottom menu, and then Network at the top. Before moving on to the transport testing, confirm that announces and messages can pass back and forth via the two RNodes. Also, make sure that both devices are not connected to the same WiFi network, as this could allow traffic to pass unintentionally via the AutoInterface that is enabled by default which can cause confusion when you're intending to test communication via the RNodes. You can also disable the AutoInterface to avoid this problem. 

#### Rnpath for Hops

The core concept of this test is to have the two regular RNodes far enough apart that they can't establish a LoRa connection directly between themselves, and to have the RTNode in the middle acting as a relay to pass their messages. To reduce the required distance between the two RNodes, obstructions can be used, such as having the RTNode on the corner of the building and other two nodes going away from each other with the building in-between. Alternatively, the transmission power on the stationary and mobile nodes can be reduced to very low (I did 5 but it could be 1) in the MeshChat interface config options. The transmission power on the RTNode should stay high. Then the RTNode can be placed some distance away from the stationary node in the direction the mobile node will travel. And the mobile node keeps moving away while doing the test, but the distance it has to travel will be less due to the low transmission power settings.

The version of the test described below assumes there is a person with mobile node and a second person with the stationary node. In theory the test could be attempted by one person with some version of the stationary side of the test automated with a script.

Here is how the test works: the mobile node sends messages periodically to the stationary node as they are moving away. The stationary node receives a message, and then runs the rnpath command to the hash of the mobile node (visible in the conversation view in MeshChat):

```
rnpath ********************************
```

And it will return the info it has on the path to that destination, as stored in the local RNS routing table. Besides the destination hash itself, this includes only three other pieces of information:

- The number of hops it takes to reach the destination.
- The hash of the first intermediary hop on the path to the destination.
- The local interface through which the destination was reached.

This is all the information that any node ever has about the routing to and from any other node. It is very limited, and this is by design in order to minimize surveillance that can be done on communication through the network.

After the stationary node runs the rnpath command, they reply to the mobile node letting them know how many hops it returns. When the mobile node is nearby, the rnpath command will report a single hop, directly between the two RNodes. However, as the mobile node gets further away it should only be able to reach the stationary one via the RTNode and once this happens then the rnpath will show two hops! Then the stationary node can send a message to the mobile node letting them know they got two hops, which means the mobile node can come back.

Assuming there were no other rogue transport nodes on the same LoRa frequency as your test, then the fact that there were two hops means that the RTNode must have worked. However, there is one last check that can be done to confirm this. The output of the rpath command will have said:

```
destination <********************************> is 2 hops away via <********************************>
```

That second hash after "via" is from your RTNode, and it should be the same as the "Transport instance identity" hash you got from the RTNode via tio back at the beginning! The intermediary hash from the rnpath being the same as the identity hash of the RTNode confirms that it was part of the route taken by the two hop message.

### Troubleshooting
There are a number of things that can go wrong with your connection between your regular RNode and your computer or phone, some I mentioned above and some I did not:

- Remember you always have to do a restart, or click an "Apply Now" button or something for changes you've made to your interface config to come into effect! Despite the big obvious buttons reminding you to do it, this can still be surprisingly easy to forget.
- Make sure that you don't have a leftover tio shell running in a terminal somewhere and hogging the serial port for your device, preventing RNS from connecting.
- USB cables are obviously either plugged in or not plugged in, but bluetooth connections are more tricky to keep track of. If you have a RNode connected to your phone over bluetooth, and then later try connecting it to your computer over USB then it won't work because it has maintained the bluetooth connection. Since bluetooth connections are actually managed by Android, it isn't enough to disable the interface in Columba, you have to go into the Android Settings > Connected devices > choose the gear next to the name of your RNode > Forget and this will clean up the connection.
- When you're establishing a new bluetooth connection to an RNode, a way to simplify the process and avoid problems is to clear all the pre-existing RNode related connections out of your Android bluetooth settings, and then also turn off any other RNodes in the vicinity (or change location so there are no other RNodes nearby) before you start bluetooth pairing your Android to your RNode.
- On Linux the number at the end of the serial device port (/dev/ttyACM#) can sometimes change, especially if you're doing flashing. If things aren't working as you expect, it never hurts to do a quick check in /dev to see if the serial port is there and how it is numbered, and also to make sure that it still matches the one listed in your interface config.
- If there's no response when you plug the RNode into Android over USB, and especially if no /dev/ttyACM# port shows up with a USB connection to Linux, then this means you might have a cable that isn't transferring data. Also, try to avoid using USB adapters or hubs, these could also cause problems.
- Sometimes the USB cable connecting to an RNode does not get a solid connection and disconnects intermittently, making everything buggy and unreliable. This seems to more often be a problem on Android devices, probably because phones are smaller and more mobile, and also because they more often have debris in their USB-C port blocking a solid connection.

## Next Steps
This guide only covers, and so far we have only done, the minimal testing to confirm that this RTNode firmware works at all as a LoRa mesh node. With this done, now the more infrastructural work can begin of testing how well it actually performs for LoRa communications across our neighbourhoods and regions. Part of the intention of this guide is to diffuse more widely the important knowledge that has come out of a smaller context of experimentation, in order to facilitate broader participation in the next phases of testing.

Based on reports online from other people doing early testing of the RTNode firmware, there was one major limitation that I expected we would run into as we scale up our testing: the RTNodes interface to LoRa was configured in Access Point mode which meant that it didn't pass any announces and may be limited in how much it can be used to chain together multi-hop connections. However, in the past week there was a new release of RTNode that fixed this problem by changing the LoRa interface to Full Mode, which will allow it to pass on local announces! More testing will be required to confirm how well this actually works, but the [release notes](https://github.com/jrl290/RTNode-HeltecV4/releases/tag/v1.0.28) are promising.

For further testing, it will definitely be worth confirming that IFACs work over LoRa on the RTNode firmware. IFAC stand for Interface Access Code, and it allows setting a username and password for anyone to be able to communicate over that interface. This allows the entire Reticulum packet to be encrypted, including the header, meaning that anyone monitoring the radio waves just sees LoRa-shaped data that is all random/encrypted with no meaningful metadata about what kind of communication is happening.

It would also be worth trying out the local WiFi and internet connection options for the RTNode firmware. Even if LoRa networks are a priority for many of us, better understanding how these other interface options work in practice will give us a better basis for figuring out how they can be useful for building networks in different situations. We should also keep trying out other firmware as it gets further developed: such as ones with support for the more resource constrained but also much more power-efficient nRF52 boards. Thank you for reading until the end, I look forward to seeing you on the rooftops and in the streets!

## Other firmware

See also those firmware projects:

- [`attermann/microReticulum_Firmware`](https://github.com/attermann/microReticulum_Firmware): RNode firmware integrating
  the [microReticulum](https://github.com/attermann/microReticulum) stack which implements a full transport node
  (documented above), see also the [Ratspeak fork](https://github.com/ratspeak/microReticulum)
- [`RatTunnel`](https://github.com/hipstereclipse/rns-transport-wisblock1w) - used on the west coast on RAK solar nodes, with
  console commands, 200 entry routing table with SNR tracking,
  integration with [`Rathole`](https://github.com/ratspeak/rathole)
- [untested Ethernet gateway firmware](https://rns.recipes/forum/showcase/rnode-over-ethernet-rak4631-rak13800-ethernet-module)
