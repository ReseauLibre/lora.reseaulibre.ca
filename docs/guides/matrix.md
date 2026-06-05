# Matrix guides

The Réseau Libre project encourages the use of Matrix instead of
proprietary platforms like Discord, Telegram or Facebook. This page
explains how to get onboard and use Matrix to run bridges with the
mesh.

You can read the rationale behind that choice [in the "Why Matrix?"
FAQ](faq.md#why-matrix).

## How do I join the Matrix room?

So how do you actually join Matrix?

There are many guides for this, but the [`joinmatrix.org` guide is
pretty good](https://joinmatrix.org/). Essentially, it is:

 1. Register on a home server
 2. Download a client, app, or use a web client
 3. Join the room

### Picking a home server

Here are home servers we recommend:

- **Matrix.org**: even though they do not recommend you create an account
  there because their server is busy, it's still possible to create a
  `matrix.org` account on [`app.element.io`](https://app.element.io/)

- **Mozilla.org**: the people who make the Firefox web browser. Go to
  [chat.mozilla.org](https://chat.mozilla.org/) (which also serves as web client) and click on
  "Continue with...", you can sign up with an already existing Mozilla
  Accounts, GitHub, or Google account

- **FSFE**: the European Free Software Foundation [runs a Matrix
  server for its members](https://docs.fsfe.org/en/techdocs/matrix), requires a donation, see
  [`chat.fsfe.org`](https://chat.fsfe.org/)

- Linux distributions:

  - **Debian**: people with an account on the [Debian GitLab server](https://salsa.debian.org/)
    ("salsa") can access the [`debian.social`](https://element.debian.social/) home server

  - **Ubuntu**: members can use [register on the `ubuntu.com` home
    server](https://ubuntu.com/community/docs/communications/matrix/register-ubuntu-com)

  - **Fedora**: people with a [Fedora account](https://accounts.fedoraproject.org/) can use the
    [`fedora.im` home server](https://chat.fedoraproject.org/)

  - **Arch**: team members can [use the `archlinux.org` home server](https://github.com/archlinux/infrastructure/blob/master/docs/matrix.md)

- Other servers:

  - [`Unredacted`](https://unredacted.org/services/si/matrix/) - privacy focused, based in the United States
  - [`tchncs.de`](https://tchncs.de/en/matrix) - based in Germany, also offers [other federated
    services](https://tchncs.de/)

There is also [this list of home servers accepting registration from
the public](https://servers.joinmatrix.org/).

### Picking an app

We recommend those:

- [Element X](https://matrix.org/ecosystem/clients/element-x/): flagship mobile app
- [Element](https://matrix.org/ecosystem/clients/element/): flagship desktop app
- [FluffyChat](https://matrix.org/ecosystem/clients/fluffychat/): good mobile, desktop app
- [Cinny](https://cinny.in/): good desktop, minimalist, desktop app

If you want to use the web interface, your home server provider likely
provides one (above), otherwise use the official instance at
[`app.element.io`](https://app.element.io).

### Joining the room

Normally, clicking the [`#reseaulibre:matrix.org` Matrix room](https://matrix.to/#/#reseaulibre:matrix.org) from
your browser should work, by opening the desktop client.

If not, you can type `/join #reseaulibre:matrix.org` in any chat
window, or enter the `#reseaulibre:matrix.org` URL in the "join" (in
element it's "Search") interface of your client.

This is the main room, but there are other rooms in the space,
[`#reseaulibre-space:matrix.org` Matrix room](https://matrix.to/#/#reseaulibre-space:matrix.org).

## Videoconferencing

Matrix supports audio and video calls. There are two different
implementation:

- legacy, built on top of the Jitsi server at
  <https://meet.element.io/> (but that can be modified for other Jitsi
  servers)
- native, or "[Element call](https://github.com/element-hq/element-call/)", which is built on top of
  [`Livekit`](https://livekit.com/), a WebRTC framework that is slightly easier to deploy
  than Jitsi, and federates better (each server can run its own
  Livekit, whereas Element effectively runs all the legacy calls)

We're currently experimenting with Legacy calls, as we want to allow
outside people to participate in our calls.

Out of the box, the way legacy calls work is they build a unique
(think [UUID](https://en.wikipedia.org/wiki/Universally_unique_identifier)) identifier for the room, and embed this as a
widget. You can find that room identifier by typing this in a Element
chat window:

    /devtools

Then select "Active widgets", where you'll see a button like:

    https://scalar.vector.im/api/widgets/jitsi.html

Select that, and look for the `conferenceId`, for example:

    "conferenceId": "8be4df61-93ca-11d2-aa0d-00e098032b8c",

Then you can tell people to join that room at:

<https://meet.element.io/$conferenceId>

For example, in the case above:

<https://meet.element.io/8be4df61-93ca-11d2-aa0d-00e098032b8c>

The widget should also be visible in `Explore room state` then
`im.vector.modular.widgets`.

You can also *change* that widget to point to an *existing* Jitsi room
that you control better, for example a [moderated meeting](https://moderated.jitsi.net/). In the
first example, change the `domain` to `meet.jit.si` and the
`conferenceId` to the "guest" link, then click "Send", which will
update the room to point to the new widget.
