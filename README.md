# wiki-wrapper
Github/Gitit wiki-wrapper Enable usage of either (or both) wiki-system for
projects documentation

## License and copyright
![CC BY-SA logo](https://licensebuttons.net/l/by-sa/3.0/88x31.png)

This wiki-wrapper is licensed under Creative Commons license `CC BY-SA`

Copyright: _Michael Ambrus <michael@helsinova.se> 2018_

For re-use of the wiki-wrapper, see file [USAGE.md]()

# Project Documentation

All documentation of this project is a Wiki. If you read this, the Wiki can
be read and managed locally on Linux/Posix OS:es. Start reading in these
simple steps:

1) Get all sub-modules - documentation is one of them
```
    git submodule init
    git submodule update
```

**Note:** The git-module wikidata contains the actual content and may
intentionally differ between git-projects, versions and branches.

2) Install `gitit` & `Pandoc` if you haven't already:

http://gitit.net/Installing


3) Execute the following:

_(Prerequisite: `screen` the terminal emulator)_

```bash
./start_wiki.sh
```

_Note that there is a help to the script. Use `-h` for up-to-date details._

4) Browse the Wiki:

The script will open the first page in a browser. If not, note the URL
*including* the port printed on `stdout` by `./start_wiki.sh` and copy&paste
that into your web-browser.

