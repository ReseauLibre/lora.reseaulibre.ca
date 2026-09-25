# How this website is built

[![Pipeline status](https://ci.codeberg.org/api/badges/16463/status.svg)](https://ci.codeberg.org/repos/16463)

This is the source code for the new Montreal Mesh website, currently
hosted at <https://lora.reseaulibre.ca> and backed by Codeberg at
<https://codeberg.org/anarcat/lora-reseaulibre-ca/>.

This README file documents the git repository and how to make changes
to the site. The actual site contents are in the `docs/` directory of
the [git repository](https://codeberg.org/anarcat/lora-reseaulibre-ca/) or on [lora.reseaulibre.ca](https://lora.reseaulibre.ca).

## Mirrors

The git repository is primarily hosted on Codeberg, but has multiple
mirrors:

- Codeberg: <https://codeberg.org/reseaulibre/lora-reseaulibre-ca/>
- sr.ht: <https://git.sr.ht/~anarcat/lora.reseaulibre.ca>
- GitLab: <https://gitlab.com/reseaulibre/lora.reseaulibre.ca>

Those are synchronized automatically on push in Codeberg or, if
Codeberg is unavailable, manually.

## Contributing

If you want to participate here, agree with the [Code of Conduct](code.md)
([Contributor Covenant 3.0 Code](https://www.contributor-covenant.org/version/3/0/code_of_conduct/)), and edit the files in the
`docs/` directory which should bring you into a [pull request
workflow](https://docs.codeberg.org/git/clone-commit-via-web/#edit).

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
switched to [Zensical](https://zensical.org/), then back to mkdocs-material because
[blog](https://github.com/zensical/backlog/issues/30) (fixed) and [RSS](https://github.com/zensical/backlog/issues/27) support are missing.

See the [authoring guide](https://squidfunk.github.io/mkdocs-material/reference/) for more information on formatting the contents.

## Copyright

The content of this repository is available under the [Creative
Commons Attribution-ShareAlike 4.0 International license](https://creativecommons.org/licenses/by-sa/4.0/), and so
will be your contributions:

> 💡 License
>
> You are free to:
> 
>  - **Share** — copy and redistribute the material in any medium or format for any purpose, even commercially.
>  - **Adapt** — remix, transform, and build upon the material for any purpose, even commercially.
>  - The licensor cannot revoke these freedoms as long as you follow the license terms.
> 
> Under the following terms:
> 
>  - **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made. You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
>  - **ShareAlike** — If you remix, transform, or build upon the material, you must distribute your contributions under the same license as the original.
>  - *No additional restrictions — You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.

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

## Structure

The documentation is structured partly following the [Diataxis
method](https://diataxis.fr/) where we separate introduction and in-depth material in
separate sections. We try to have at least a section (the [guides](guides/index.md),
but also the "about" menu) that assume as little prior knowledge as
possible, in opposition to the more in-depth and "dump everything
there" [references](references/index.md) section.

In guides, instructions are clear, direct, quick and to the
point.

> [!NOTE]
> Some instructions can diverge from that path, but they marked
> clearly with an [admonition](https://squidfunk.github.io/mkdocs-material/reference/admonitions/), like here.

## Links and navigation

The navigation menus are maintained by hand in the `mkdocs.yml`
file. The build will warn if a file is added to the repository without
being added to the `nav` dictionary there. Heed those warnings and
properly add files to the structure. An exception is the blog posts
which don't need to be individually added.

Each page should somehow be reachable from the front page, but not
necessarily as a direct link. Each *section* should be linked there,
and then each page should be listed in each section.

It's a bit cumbersome, but it makes it easier to find pages when
navigation is less visible, for example on mobile or other renderings
of the site. (For example, the Reticulum Micron rendering doesn't
replicate the navigation menus at all and can *only* rely on in-page navigation.)

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

The link checker does *not* enforce the constraint of linking every
section from the front page and section pages mentioned in the
previous section, but it should.

## Spell checking

Good old [Aspell](https://en.wikipedia.org/wiki/GNU_Aspell) is used to check spelling in English and French.

To fix false positives found by Aspell, install the `aspell` package
and run the command recommended by CI, which should be something like:

    aspell --mode=markdown --lang=fr --home-dir=. --personal=aspell.fr.pws --encoding=utf-8 foo.md

... where `foo.md` is the file with a problem. It will run a text
interface that will allow you to correct or accept the words.

Alternatively, you can add the word to the list in `aspell.fr.pws`
following the [peculiar file format](http://aspell.net/man-html/Format-of-the-Personal-and-Replacement-Dictionaries.html#Format-of-the-Personal-and-Replacement-Dictionaries). Essentially, you need to add
the word on its own line and increment the line count on the first
line.

Finally, if you use `backquotes` around a word, it will get excluded
by the parser, which can be useful to bypass certain words marked as
failures. This is particularly useful for project names that won't get
reused or can't be added because they have a separator not recognized
by Aspell. For example, Meshtastic is in our dictionary so it doesn't
need to be quoted, but not `grebedoc.dev`, which does need back
quotes. 

(Astute readers will notice that `backquotes` itself needs back
quotes, as it's an incorrect spelling, according to Aspell. Capitals
matter as well: `aspell` is a typo, but not Aspell, of course.)

## CI build workflow details

This section explains how the site is built. You don't need to read
this unless you want to debug the continuous integration (CI) process
or website build.

The way this is setup is rather convoluted because we need to have a
custom domain and this is still not yet well supported by the new "git
pages" and "actions" in Codeberg. So, essentially, it works like this:

1. on push, Codeberg somehow notifies <https://ci.codeberg.org> which
   is Woodpecker CI instance
2. woodpecker pulls the git repository, builds the site, and commits the
   result to the `pages` branch
3. woodpecker pushes the branch back to Codeberg
4. code berg fires off a webhook to publish the site to git pages

### First setup

To set this up, I had to first [follow the manual pushing guide](https://docs.codeberg.org/codeberg-pages/pushing-output/):

1. build the site on the `main` branch
1. create an "orphan" `pages` branch (`git switch --orphan pages`) for
   the site
1. add and commit the `site` directory, but to the root of the repository
1. setup a [webhook to the legacy v2 pages](https://docs.codeberg.org/codeberg-pages/#repository-websites) on push (update: now a
   [webhook to Grebedoc](https://grebedoc.dev/#own-domain) instead)
1. push the `pages` branch

At this point, `anarcat.codeberg.page/lora-reseaulibre-ca` is
online. Next up was to setup the [custom domain](https://docs.codeberg.org/codeberg-pages/using-custom-domain/):
   
1. add a CNAME for `lora.reseaulibre.ca` at my registrar, pointing at
   `lora-reseaulibre-ca.anarcat.codeberg.page.` (update: now pointing
   at `grebedoc.dev.`
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

### Switch to Grebedoc

As of 2026-05-26, we have switched to [Grebedoc][] because we hope it
will be faster than Codeberg pages. It also provides redundancy: if
Codeberg fails, Grebedoc should survive and vice versa, which gives us
better redundancy. It also shows us how we can host this anywhere we
can run [`git-pages`][], which can be any virtual machine we spin up
in case of a catastrophe, see also below for [Alternatives](#alternatives).

 [`git-pages`]: https://codeberg.org/git-pages/git-pages

We setup those two DNS records:

```
_git-pages-repository.lora IN TXT https://codeberg.org/reseaulibre/lora-reseaulibre-ca.git
_git-pages-challenge.lora IN TXT 6697376e11b3ff01b4f4ab83956c2742f065e60239f3e0bdb78caf73f9624cab
```

The first tells the `git-pages` software which repository is an
acceptable source for the site.

The second is the result of:

```
printf "$DOMAIN $GIT_PAGES_PASSWORD" | sha256sum
```

where `domain` is `lora.reseaulibre.ca`. The password is stored in my
password manager as `grebedoc.dev`.

It allows for pushing arbitrary content to the site.

A first push is done with:

```
curl https://grebedoc.dev/ -X PUT -H "Host: lora.reseaulibre.ca" -H "Authorization: Pages $GIT_PAGES_PASSWORD" --data "https://codeberg.org/anarcat/lora-reseaulibre-ca.git"
```

The `Authorization` header might not be necessary since we're passing
the git repository URL here.

This will fail if the DNS has not propagated yet. 

This also fails, perhaps for a different reason:

```
export GIT_PAGES_PASSWORD
git-pages-cli --server https://grebedoc.dev --upload-dir . http://lora.reseaulibre.ca/
```

Unclear.

The `--password "$GIT_PAGES_PASSWORD"` is implicit as it looks for the
`GIT_PAGES_PASSWORD` environment, see the [`git-pages-cli` README file](https://codeberg.org/git-pages/git-pages-cli).

Once a first push has been made, we can switch over by changing DNS
to:

    lora IN CNAME grebedoc.dev.

Then a new webhook need to be added following [those instructions](https://grebedoc.dev/#own-domain),
essentially:

> Select repository > Settings > Webhooks > Add webhook > Forgejo, then configure only the following:
>
> - Target URL: `http://lora.reseaulibre.ca`
> - Branch filter: `pages`
> - Authorization header: `Pages {password}` (Method B only)
>
> Leave everything else at the default values and select `Add
> webhook`.

Then this can be tested by pushing to the `pages` branch, which can be
done by doing a regular commit on the site, or on the `pages` branch
of course.

The CI configuration is actually unchanged.

### Alternatives

We should probably hook this onto [Forgejo Actions](https://docs.codeberg.org/ci/actions/) and the
[git-pages action](https://codeberg.org/git-pages/action), instead. The [guide for that](https://docs.codeberg.org/codeberg-pages/forgejo-actions/) explicitly
says it does not work for custom domains, although that might now be
inaccurate, since we've published the site on a `git-pages` back-end
(Grebedoc) without problems since 2026-05-26.

We're in the process of migrating to Codeberg actions. We've had
trouble with the cache and artifacts action which both need node, so
for now it reuses the git-based caching logic used by
Woodpecker. We've also found the actions pipeline to be much slower
than the Woodpecker pipelines, so much so that it would timeout and,
ultimately, made migration impossible, so we're still on Woodpecker.

There was a downtime on Codeberg on 2026-03-04 that cause the site to
go down almost entirely for a full 24 hours. 

If this happens again, we can consider hosting the static site
somewhere else. I was recommended [`statichost.eu`](https://www.statichost.eu/) (see [this
guide](https://www.arscyni.cc/file/codeberg.html)) or [Grebedoc][] ("Codeberg" backwards).  As of 2026-05-26,
we've switched to Grebedoc.

Updates to those sites can be posted even without Codeberg being
available, through any [`git-pages`][] compatible hosting provider,
see above.

 [Grebedoc]: https://grebedoc.dev/

We also use the `cache` branch to carry around the Lychee cache. This
could be fixed if [Woodpecker supported caches](https://github.com/woodpecker-ci/woodpecker/discussions/2296) or with a Forgejo
["cache"](https://garrido.io/notes/caching-hugo-resources-in-forgejo-actions/) or [artifacts action](https://forgejo.org/docs/latest/user/actions/advanced-features/#artifacts). Both actions require a Node
installation and are not compatible with many images.

## Matrix commit bot

Moved to [our Matrix guide](https://lora.reseaulibre.ca/guides/matrix#commit-bot).

## Reticulum publishing

Efforts are under way to publish the site as a Nomadnet Micron site,
which would make it accessible natively under [Reticulum](guides/reticulum/index.md). The goal
is to rebuild the site into Micron pages at every push, through
continuous integration.

So far two separate experiments have started:

 1. an incomplete [Pandoc output format](https://github.com/jgm/pandoc/issues/11851): this has mostly stopped
    because Pandoc is much stricter than `mkdocs` in the Markdown
    format it accepts, and fundamentally renders the site
    differently. We also haven't implemented *all* the endpoints yet,
    and have lost focus because of...

 2. the [`md2mu` converter](https://gitlab.com/anarcat/scripts/-/blob/main/md2mu.py?ref_type=heads) which reuses the [Markdown parser](https://github.com/markqvist/Reticulum/blob/master/RNS/Utilities/rngit/util.py)
    Mark wrote for [`rngit`](https://reticulum.network/manual/git.html) and, while it is not a correct (or
    even complete) Markdown implementation, it currently renders
    better than the above

The correct way to regenerate the Micron site looks like this:

    cd docs/
    python ~/bin/md2mu.py . -d ~/Projects/nomadnet-pages/

Then point `nomadnet` at the `/home/anarcat/Projects/nomadnet-pages`
directory. And no, `nomadnet` does not support the `~` expansion, so
it really needs to be the absolute path there.

The Reticulum version assumes every page is accessible without the
navigation, as the conversion doesn't currently replicate the
navigation menus (and, perhaps, shouldn't).
