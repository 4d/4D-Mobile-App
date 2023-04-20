# 4D-Mobile-App

## User documentation

https://developer.4d.com/go-mobile/

### to edit the doc

https://github.com/4d/go-mobile

## Installation

Download this component and add it to your base `Components` folder. Be sure to name it `.4dbase`

What follows contains more detailled instructions

### Download artefact or sources

1️⃣ Download sources using github `Download` button, or by going to a specific release and getting sources
- for instance for main version `Download` button will download https://github.com/4d/4D-Mobile-App/archive/refs/heads/main.zip

2️⃣ Then unzip into your `Components` folder, and rename it folder to `4D-Mobile-App.4dbase` if needed

> 💡  if your are in git a repository
> Adding `Components` or `Components/4D-Mobile-App.4dbase` in your `.gitignore` file is recommended


> 🍎 On macOS the following command line will do the job for you.
> Open a terminal, go to your component root folder (`cd /your/base/path/`) and type:

```bash
curl -sL https://raw.githubusercontent.com/4d/4D-Mobile-App/main/download.sh | sh
```

### Using git

Go to your component root folder (`cd /your/base/path/`)

and clone it

```bash
git clone git@github.com:4d/4D-Mobile-App.git Components/4D-Mobile-App.4dbase
```

or using submodule if you use already git as vcs

```bash
git submodule add git@github.com:4d/4D-Mobile-App.git Components/4D-Mobile-App.4dbase
```
