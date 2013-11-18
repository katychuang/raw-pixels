=======
raw-pixels
==========

Visualizing nutrition facts, a project started at #code4health

![Image](static/screenshot-NutritionFactsChart.png)

#Installation

Install GHC from [haskell.org/platform](http://haskell.org/platform). It should be the latest. At the time of this writing the latest version is GHC 7.6.3. It comes with cabal, which is a package manager that helps you install packages from [hackage](http://hackage.haskell.org).

The .cabal file lists dependencies.

#Usage

```sh
$ cabal build
$ dist/build/codeforhealth/codeforhealth

$ fswatch snaplets/heist/templates:static "curl http://localhost:8000/heistReload"
```


