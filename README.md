## Website setup

### Running locally (Windows and Mac)

The site is built with Jekyll, and is easy to run locally if you have Ruby.

> If you don't have Ruby version 2.5.0 or higher installed, please see the 
"Standard Setup" sections below.

Open command prompt and browse to your website's folder. To set up a "bundle" 
(local virtual environment in Python terms):

```
bundle install
```

Next, use `bundle exec` to run a command in the new environment you just 
created, such as:

```
bundle exec jekyll serve
```

This will incrementally rebuild if there were anything changes in your 
directory. Using an internet browser, browse to the server address shown in 
the output, e.g.: `http://127.0.0.1:4000`.

> To stop the server, press Control+C.

### Setup for local development

#### 1. Standard setup (Mac)

Visit [this page](https://jekyllrb.com/docs/installation/) for information about installing Ruby if your current version is too old; the instructions there form the basis for what you see here, and come in variants for all major operating systems.
You should have Ruby 2.4+ for Jekyll. Since versions of macOS before Catalina with 2.3 (and Apple is dropping scripting language from macOS in the future), you may want a newer version even on a mac. You can use rbenv to manage multiple ruby versions. On macOS with homebrew, you'll want:

```bash
brew install rbenv
```

You'll need to run:

```bash
rbenv init
# Prints out instructions
```

and follow the instructions for your current shell. After you've installed rbenv on your system, use:

```bash
rbenv install 2.7.0
```

to get a current version of ruby. Then, inside the main iris-hep website directory, run:

```bash
rbenv local 2.7.0
```

This will run the Ruby you just built whenever you enter this directory. You'll want to install bundler too:

```bash
gem install bundle
```

(You may want to add `--user-install` here if you are not using rbenv. And if
you don't have permission to install, and you are using rbenv, this means you
forgot to set it up with `rbenv init`.)

#### 2. Standard setup (Windows)

Jekyll is a Ruby Gem that can be installed on most systems. Please view the 
official [installation] instructions for Windows, or follow the below steps.


- Download and install a Ruby+Devkit version from [RubyInstaller Downloads]. 

![Ruby Installer](https://github.com/compiler-research/compiler-research.github.io/blob/master/images/rubyinstall1.png)

- Use default options for installation.

- Run the `ridk install` step on the last stage of the installation wizard. 

![Ruby Installer Screenshot 2](https://github.com/compiler-research/compiler-research.github.io/blob/master/images/rubyinstall2.png)

- This is needed for installing gems with native extensions. 

- From the options choose `MSYS2 and MINGW development tool chain`.

![Ruby Installer Screenshot 3](https://github.com/compiler-research/compiler-research.github.io/blob/master/images/rubyinstall3.png)

- On a new command prompt, type the following to enable it: 

```
ridk enable
```

- Open a new command prompt window from the start menu, so that changes to the 
PATH environment variable becomes effective. 

- Open command prompt and browse to your website's folder.

- Install Jekyll and Bundler using:

```
gem install jekyll bundler
```

- Check if Jekyll has been installed properly: 

```
bundle exec jekyll -v
```

>You may receive an error when checking if Jekyll has not been installed 
properly. Reboot your system and run jekyll -v again.


#### 3. Docker setup

If you use docker, the following line will build and serve the site locally:

```bash
docker run --rm -v "$PWD:/srv/jekyll" -p 4000:4000 -it jekyll/jekyll:3.8 jekyll serve
```

If you want to enable LiveReload (pages automatically reload when jekyll rebuilds after detecting changes), then use this instead:

```bash
docker run --rm -v "$PWD:/srv/jekyll" \
           -p 4000:4000 -p 35729:35729 \
           -it jekyll/jekyll:3.8 \
           jekyll serve --livereload
```

## Guide to Making Changes to the Website

Before making any changes to the Compiler Research website, please view the [Contibution Guide] to understand the existing site structure.


[installation]: https://jekyllrb.com/docs/installation/windows/
[RubyInstaller Downloads]: https://rubyinstaller.org/downloads/
[Contibution Guide]: https://github.com/compiler-research/compiler-research.github.io/blob/master/CONTRIBUTING.md

