# Charges Infrastructure Control

This is the control repo for the Land Registry Charges project. It contains all
the Infrastructure code necessary to provision our entire infrastructure.

**Table of Contents**

- [Security Considerations](#security-considerations)
- [Pre-requisites](#pre-requisites)
    - [Useful plugins](#useful-plugins)
    - [Install Vagrant and Virtualbox](#install-vagrant-and-virtualbox)
    - [Prerequisite Reading](#prerequisite-reading)
        - [Philosophy](https://github.com/LandRegistry/dev-vm#philosophy)
            - [In Theory](https://github.com/LandRegistry/dev-vm#in-theory)
            - [In Practice](https://github.com/LandRegistry/dev-vm#in-practice)
        - [Anatomy of the Dev VM](https://github.com/LandRegistry/dev-vm#anatomy-of-this-repo)
            - [The Puppetfile](https://github.com/LandRegistry/dev-vm#the-puppetfile)
            - [Hiera](https://github.com/LandRegistry/dev-vm#hiera)
                - [The `hiera.yaml` file](https://github.com/LandRegistry/dev-vm#the-hierayaml-file)
                - [The `/hiera` folder](https://github.com/LandRegistry/dev-vm#the-hiera-folder)
                - [The `hiera/vagrant.yaml` file](https://github.com/LandRegistry/dev-vm#the-hieravagrantyaml-file)
        - [Controlling Apps](https://github.com/LandRegistry/dev-vm#controlling-apps)
            - [Starting / Stopping / Restarting an app](https://github.com/LandRegistry/dev-vm#starting--stopping--restarting-an-app)
            - [Accessing an apps logs](https://github.com/LandRegistry/dev-vm#accessing-an-apps-logs)
            - [Accessing the databases](https://github.com/LandRegistry/dev-vm#accessing-the-databases)
- [Usage](#usage)
- [Anatomy of this repo](#anatomy-of-this-repo)
    - [Defined VMs](#defined-vms)
    - [The `manifests/site.pp` file](#the-manifestssitepp-file)
    - [The `site` folder](#the-site-folder)
    - [Hiera datafiles](#hiera-datafiles)
    - [The `bin/jenkins.sh` script](#the-binjenkinssh-script)

## Security Considerations

Currently there are no "secure" assets or configuration, e.g. Private-Public key
pairs, account passwords, usernames, etc. in this repo. **This is how it should
be.** Since all code is public this really only means the Private-Public key
pairs needed to SSH in are placed by hand on new boxes before puppet provisions
the box.

Running a `vagrant up` on this repo will allow anyone to provision our full
infrastructure locally. Since all the code for the apps is public, including
the Puppet modules which deploy those apps, we see no need to make the
infrastructure code private.

Since the Public-Private key pairs used to secure SSH in the Integration
environment are not included here *open sourcing this infrastructure code does
not detriment the security of the Integration environment.*

A cursory glance through this repo will show that there is very little happening
here, mostly just composing already public Puppet code.

## Pre-requisites

### Useful plugins

We use a few plugins in the Dev VM you should install first:

```
> vagrant plugin install vagrant-dns
> vagrant plugin install vagrant-librarian-puppet
> vagrant plugin install vagrant-cachier
```
Then start the vagrant dns plugin:
```
> vagrant dns --install
```

### Install Vagrant and Virtualbox

You also should have Vagrant and Virtualbox. Easiest way is through homebrew-cask:

Install homebrew-cask:
```
> brew install caskroom/cask/brew-cask
```
Then install the Vagrant and Virtualbox:
```
> brew cask install vagrant
> brew cask install virtualbox
```

## Prerequisite Reading

This README assumes you have already read the [Dev VMs README](https://github.com/LandRegistry/dev-vm),
which explains many of the concepts used in this repo.

- [Philosophy](https://github.com/LandRegistry/dev-vm#philosophy)
    - [In Theory](https://github.com/LandRegistry/dev-vm#in-theory)
    - [In Practice](https://github.com/LandRegistry/dev-vm#in-practice)
- [Anatomy of the Dev VM](https://github.com/LandRegistry/dev-vm#anatomy-of-this-repo)
    - [The Puppetfile](https://github.com/LandRegistry/dev-vm#the-puppetfile)
    - [Hiera](https://github.com/LandRegistry/dev-vm#hiera)
        - [The `hiera.yaml` file](https://github.com/LandRegistry/dev-vm#the-hierayaml-file)
        - [The `/hiera` folder](https://github.com/LandRegistry/dev-vm#the-hiera-folder)
        - [The `hiera/vagrant.yaml` file](https://github.com/LandRegistry/dev-vm#the-hieravagrantyaml-file)
    - [Controlling Apps](https://github.com/LandRegistry/dev-vm#controlling-apps)
        - [Starting / Stopping / Restarting an app](https://github.com/LandRegistry/dev-vm#starting--stopping--restarting-an-app)
        - [Accessing an apps logs](https://github.com/LandRegistry/dev-vm#accessing-an-apps-logs)
        - [Accessing the databases](https://github.com/LandRegistry/dev-vm#accessing-the-databases)

## Usage

First clone the repo:

```
> git clone git@github.com:LandRegistry/dev-vm.git
```

Then install the dependencies:

```
> librarian-puppet install
```

Add an environment variable that points at your development folder (e.g. mine is
in `~/Projects/land-registry/charges`) to your `~/.bashrc` or `~/.zshrc`:

```
> echo "export development=/path/to/your/code" >> ~/.zshrc
```

And finally you can start the VM:

```
> vagrant up
```

And wait, and wait, and wait.

## Anatomy of this Repo

### Defined VMs

The [`Vagrantfile`](https://github.com/LandRegistry/charges-control/blob/master/Vagrantfile#L4)
defines a number of VMs so that you can mimic Integration locally. This allows you
to run a change locally and predict whether it will break Integration.

The list of defined VMs is in the [`Vagrantfile`](https://github.com/LandRegistry/charges-control/blob/master/Vagrantfile#L4).

### The `manifests/site.pp` file

Each box or VM deployed to by Control is provisioned based on the node it matches
in [`site.pp`](https://github.com/LandRegistry/charges-control/blob/master/manifests/site.pp).

Nodes are named and the name is used by puppet to determine which node to use for
a VM or box.
```ruby
node 'deedapi' {
  include ::profiles::deedapi
}
```
In this definition any VMs named `deedapi`, `deedapi.foo`, `deedapi.foo.bar.gov.uk`,
etc will be defined based on that node. We use the profiles concept to disconnect
apps from the nodes themselves, so one box could perform the role of Deed Api and
Scribe if you want.

Profiles are stored in [The `site` folder](#the-site-folder).

### The `site` folder

Profiles are stored in this folder. A profile is just a Puppet class that composes
the required classes for a box to perform in a given role. For example you may
need the App itself, the Standard Environment (python, gcc, etc), a hardened
Nginx and IPTables configuration, etc. So we don't overly bog down the developers
we only expect Puppet modules in each App to know how to deploy that App, not
fully harden it for production use.

### Hiera datafiles

Like in the Dev VM we use Hiera for overriding configuration values. This time
though we have multiple files, which store the correct config for each box. The
correct datafile is chosen based on the Fully Qualified Domain Name. This FQDN
should be identical to the URL of the box, whether that is through external public
DNS or internal DNS.

### The `bin/jenkins.sh` script

This script, located in [`bin/jenkins.sh`](https://github.com/LandRegistry/charges-control/blob/master/bin/jenkins.sh),
is used by jenkins to run puppet on each box it should deploy on to. It requires
only one variable, `$WORKSPACE`, which is the location jenkins has checked out
this repo to on the box.

This script will wire together the different folders needed, install the modules
needed, and then run `puppet apply`. Since the configuration of a box is based on
it's FQDN we don't need any change from box to box. Puppet will find the correct
[node](#the-manifestssitepp-file) and [hiera](#hiera-datafiles) file and perform
the installation.
