This is the source code for the new Montreal Mesh website, currently
hosted at <https://lora.reseaulibre.ca>.

Most contents are in [docs](docs/index.md).

# Meta

The way this is setup is rather convoluted because we need to have a
custom domain and this is still not yet well supported by the new "git
pages" and "actions" in Codeberg. So, essentially, it works like this:

1. on push, codeberg somehow notifies <https://ci.codeberg.org> which
   is Woodpecker CI instance
2. woodpecker pulls the git repo, builds the site, and commits the
   result to the `pages` branch
3. woodpecker pushes the branch back to codeberg
4. codeberg fires off a webhook to publish the site to git pages

## Contributing

If you want to participate here, agreed with the [Code of Conduct](CODE_OF_CONDUCT.MD)
([Contributor Covenant 3.0 Code](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)), and edit the files in [docs](docs/)
which should bring you into a [pull request workflow](https://docs.codeberg.org/git/clone-commit-via-web/#edit).

Once the request is approved, your changes will go live. Changes take
a "few minuets" to show up, see [this troubleshooting section
otherwise](https://docs.codeberg.org/codeberg-pages/troubleshooting/#my-content-is-not-updated).

The site was originally build on [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) but eventually
switched to [Zensical](https://zensical.org/). See their [authoring guide](https://zensical.org/docs/authoring/markdown/) for more
information.

## First setup

To set this up, I had to first [follow the manual pushing guide](https://docs.codeberg.org/codeberg-pages/pushing-output/):

1. build the site on the `main` branch
1. create an "orphan" `pages` branch (`git switch --orphan pages`) for
   the site
1. add and commit the `site` directory, but to the root of the repo
1. setup a [webhook to the legacy v2 pages](https://docs.codeberg.org/codeberg-pages/#repository-websites) on push
1. push the `pages` branch

At this point, `anarcat.codeberg.page/lora-reseaulibre-ca` is
online. Next up was to setup the [custom domain](https://docs.codeberg.org/codeberg-pages/using-custom-domain/):
   
1. add a CNAME for `lora.reseaulibre.ca` at my registrar, pointing at
   `lora-reseaulibre-ca.anarcat.codeberg.page.`
1. add `lora.reseaulibre.ca` to the `.domains` file in the git
   repository, on the `main` branch
1. push the main branch

At this point `lora.reseaulibre.ca` is online. The next step was to
use [Codeberg CI](https://docs.codeberg.org/ci/) to build and publish the site automatically:

1. [enroll into Codeberg CI](https://docs.codeberg.org/ci/), see [issue 1570](https://codeberg.org/Codeberg-e.V./requests/issues/1570)
1. login to <https://ci.codeberg.org>
1. add the project to Woodpecker
1. create an [access token for Woodpecker](https://codeberg.org/user/settings/applications) in Codeberg
1. add the access token to a `codeberg_token` variable in the
   Woodpecker project
1. create a new `mail` variable with some dummy email on my domain in
   the woodpecker project
1. push a trivial change to a markdown file

At this point, changes to the repository automatically rebuild and
publish the changes.

We should probably hook this onto [Forgejo Actions](https://docs.codeberg.org/ci/actions/) instead, but
the [guide for that](https://docs.codeberg.org/codeberg-pages/forgejo-actions/) explicitly says it does not work for custom
domains.
