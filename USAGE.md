## This directory and it's origin:

This directory is a _wiki wrapper_ for two Wiki-systems. It enables either
local usage with [`Gitit`](https://github.com/jgm/gitit) or on-line with
[`Github`](https://help.github.com/articles/about-github-wikis/) 

The `origin` of this wrapper is [wiki-wrapper](https://github.com/helsinova/wiki-wrapper)

A reference project using _wiki-wrapper_ is the
[`ehwe`](https://github.com/helsinova/ehwe) project, more specifically the
[`wiki/`](https://github.com/helsinova/ehwe/tree/master/wiki) directory.

Feel free to browse around in the project, especially the `.gitmodules`file.

### Re-using the wrapper

This section describes how to set up a wiki for you project using
_wiki-wrapper_.

* In your projects sources, add
 [wiki-wrapper](https://github.com/helsinova/wiki-wrapper) as follows:

* From copied template, edit the `wiki.conf` and modify the port-number to
  something unique.
* Create a Wiki in your `Github` project using the web.
* Browse the created Wiki. Pick up the *Clone URI* from the _"Clone this wiki
  locally"_ field.

#### Finalizing as Git sub-module

* In your project and in the directory where the wrapper resides (preferably
  named `wiki/`, execute the following:

##### Straight-forward (basic) setup

```bash
git remote add wikidata https://github.com/account/projec.wiki.git
```

Your `.gitmodules` file would look something similar to this (adjust yours if
needed):

```
[submodule "wiki/wikidata"]
     path = wiki/wikidata
     url = https://github.com/account/projec.wiki.git
     branch = master
     ignore = all
```

##### Advanced setup

If you have several different `remotes` that host your project, and especially
if your project is on network file-system (or constantly synced among hosts)
where you will end up with 3 or more different remotes to maintain, you should
consider using git's `InsteadOf` feature when having git sub-modules and use a
symbolic name for everything (project nd sub-modules i.e.). Below we use the
symbolic URI `ssh://siterepo/`:

```bash
git remote add wikidata ssh://siterepo/project.wiki.git
```

Your `.gitmodules` file would look something similar to this:

```
[submodule "wiki/wikidata"]
     path = wiki/wikidata
     url = ssh://siterepo/project.wiki.git
     branch = master
     ignore = all
```

###### Contributor's `~/gitconfig`

* On your various hosts in your `~/gitconfig` you'd have either:

```
[url "ssh://someaccount@somewhere:/some/path/"]
    insteadOf = ssh://siterepo/
```

* Or:

```
[url "ssh://git@github.com/account/"]
    insteadOf = ssh://siterepo/
```

* Or on a host where you lack Github ssh key-exchange:

See _"Non-contributor's  `~/gitconfig`"_ below.

###### Non-contributor's  `~/gitconfig`

```
[url "https://github.com/account/"]
    insteadOf = ssh://siterepo/
```

_Note: `Github` supports as of writing ONLY `https://` for wiki's. I.e. for
cloning, your users need to have a Github account._
