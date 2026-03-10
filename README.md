This is the source code for the new Montreal Mesh website, currently
hosted at <https://lora.reseaulibre.ca>.

[![Pipeline status](https://ci.codeberg.org/api/badges/16463/status.svg)](https://ci.codeberg.org/repos/16463)

Most contents are in [docs](docs/index.md).

# Contributing

If you want to participate here, agree with the [Code of Conduct](CODE_OF_CONDUCT.MD)
([Contributor Covenant 3.0 Code](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)), and edit the files in [docs](docs/)
which should bring you into a [pull request workflow](https://docs.codeberg.org/git/clone-commit-via-web/#edit).

> 💡 Tip
>
> That can be done through the web interface directly, even though the
> linked documentation above doesn't make that obvious. The
> documentation seems to favor a local, git-based workflow which is
> more complicated, but also supported.

Once the request is approved, your changes will go live. Changes take
a "few minuets" to show up, see [this troubleshooting section
otherwise](https://docs.codeberg.org/codeberg-pages/troubleshooting/#my-content-is-not-updated).

The site was originally built on [mkdocs-material](https://squidfunk.github.io/mkdocs-material/) but eventually
switched to [Zensical](https://zensical.org/), then back to mkdocs-material to get the
blog working. See their [authoring guide](https://squidfunk.github.io/mkdocs-material/reference/) for more information.

## Translations

Translations used to be made with the [mkdocs-static-i18n](https://github.com/ultrabug/mkdocs-static-i18n)
plugin. That approach has been abandoned because it conflicts with the
[blog plugin](https://squidfunk.github.io/mkdocs-material/plugins/blog/) (see upstream issues on [both](https://github.com/ultrabug/mkdocs-static-i18n/issues/283) [projects](https://github.com/squidfunk/mkdocs-material/issues/4863)). We
have therefore adopted a "two-site" approach where each language is
its own site.

This is done by having the translation in separate
branches. Concretely, we only translate to "French" right now, which
lives in the `fr` branch. The way this works is by merging the `main`
branch into the `fr` branch whenever we update the main branch. This
is a clunky, manual process, but given we don't have many
translations, it feels like a good deal.

What this implies is that updates to existing pages will necessarily
result in conflicts in the translation. That's a feature: one needs to
know when a section needs an update.

Note that the translation branch has a copy of *all* the files here,
even though a lot of those are superfluous (like the
`.woodpecker.yaml` file). The `mkdocs.yml` *is* relevant, however, and
differs between the two because the `site_url` needs the `fr` suffix.

### Translating pages

 1. First pull the repository to have all branches up to date:

        git pull

 2. Switch to the translation branch:

        git switch fr

 3. Update it with the main branch:

        git merge main

    If this is an update on an existing page, this will result in a
    merge conflict. Don't panic.

 4. Translate a given page:

        $EDITOR docs/foo.md

    If this is an existing page, you will need to resolve the merge
    conflict. See the [Codeberg merge conflict instructions](https://docs.codeberg.org/collaborating/resolve-conflicts/) for a
    tutorial. When the conflict is resolved, you mark the file as
    resolved with:

        git add docs/foo.md

 5. Commit the result and push:

        git commit -m'translate page foo'
        git push

The last step will require you to setup a remote to your own fork if
you don't have access to the repository.

## Link checks

The `checklinks` job uses the [Lychee link checker](https://github.com/lycheeverse/lychee/) to check the
site for dead links.

Checks sometimes fail because of transient errors like:

    [ERROR] https://lora.reseaulibre.ca/fr/blog/archive/2026/ | Network error: HTTP/2 protocol error. Server may not support HTTP/2 properly (error sending request for url (https://lora.reseaulibre.ca/fr/blog/archive/2026/)): HTTP/2 protocol error. Server may not support HTTP/2 properly

Rerunning the pipeline fixes this issue. I assume this is a problem
internal to Codeberg pages, but I haven't debugged the issue any
further.

Links truly being mismatched by Lychee can be added to the
`.lycheeignore` file.

## Spell checking

Two spell checkers are in use. [Typos](https://github.com/crate-ci/typos/) is used to check the English
version and good old [Aspell](https://en.wikipedia.org/wiki/GNU_Aspell) for other languages.

To fix false positives found by Typos, follow [this guide](https://github.com/crate-ci/typos/?tab=readme-ov-file#false-positives).

To fix false positives found by Aspell, install the `aspell` package
and run the command recommended by CI, which should be something like:

    aspell --mode=markdown --lang=fr --home-dir=. --personal=aspell.fr.pws --encoding=utf-8 foo.md

... where `foo.md` is the file with a problem. It will run a text
interface that will allow you to correct or accept the words.

Alternatively, you can add the word to the list in `aspell.fr.pws`
following the [peculiar file format](http://aspell.net/man-html/Format-of-the-Personal-and-Replacement-Dictionaries.html#Format-of-the-Personal-and-Replacement-Dictionaries). Essentially, you need to add
the word on its own line and increment the line count on the first
line.

# CI build workflow details

This section explains how the site is built. You don't need to read
this unless you want to debug the continuous integration (CI) process
or website build.

The way this is setup is rather convoluted because we need to have a
custom domain and this is still not yet well supported by the new "git
pages" and "actions" in Codeberg. So, essentially, it works like this:

1. on push, codeberg somehow notifies <https://ci.codeberg.org> which
   is Woodpecker CI instance
2. woodpecker pulls the git repo, builds the site, and commits the
   result to the `pages` branch
3. woodpecker pushes the branch back to codeberg
4. codeberg fires off a webhook to publish the site to git pages

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

## Alternatives

We should probably hook this onto [Forgejo Actions](https://docs.codeberg.org/ci/actions/) and the
[git-pages action](https://codeberg.org/git-pages/action), instead, but the [guide for that](https://docs.codeberg.org/codeberg-pages/forgejo-actions/) explicitly
says it does not work for custom domains.

There was a one day downtime on Codeberg on 2026-03-04 that cause the
site to go down almost entirely. If this happens again, we can
consider hosting the static site somewhere else. I was recommended
[statichost.eu](https://www.statichost.eu/) (see [this guide](https://www.arscyni.cc/file/codeberg.html)) or [grebedoc.dev](https://grebedoc.dev/)
("codeberg" backwards). This might be difficult to deploy while the
site is down, unless another Git hosting platform is used.

We also use the `cache` branch to carry around the Lychee cache. This
could be fixed if [Woodpecker supported caches](https://github.com/woodpecker-ci/woodpecker/discussions/2296) or with a Forgejo
["cache" action](https://garrido.io/notes/caching-hugo-resources-in-forgejo-actions/) or [artifacts](https://forgejo.org/docs/latest/user/actions/advanced-features/#artifacts).
