# Vagrant Meteor App Starter 
### (Work in Progress - Not Fully Functional)

A Meteor project starter, utilizing a Vagrant VM (default: Ubuntu 12.04 Precise Pangolin 32-bit) provisioned with Chef Solo.

Cookbooks included:

* [apt](https://github.com/opscode-cookbooks/apt)
* [build-essential](https://github.com/opscode-cookbooks/build-essential)
* [curl](https://github.com/retr0h/cookbook-curl)
* [meteor](https://github.com/shoebappa/vagrant-meteor-windows) - Included in ```proj-cookbooks``` folder as it can't be downloaded by Librarian-Chef. Also renamed to just "meteor".
* [nodejs](https://github.com/mdxp/nodejs-cookbook.git)
* [vim](https://github.com/opscode-cookbooks/vim)

## Dependencies

* [VirtualBox](https://www.virtualbox.org/)
* [Ruby](http://www.ruby-lang.org/en/)
* [Vagrant](http://vagrantup.com/)
* [Vagrant Librarian-Chef](https://github.com/jimmycuadra/vagrant-librarian-chef)

## Usage

Clone it into your project folder.

```bash
$ git clone https://github.com/devert/vagrant-meteor-app-starter [proj-name]
$ rm -rf .git
```

Open the vagrant/Vagrantfile and modify *proj-name* instances to the name of your project. Modify the Node.js version you would like installed in the *chef.json* attributes.

```bash
$ vagrant plugin install vagrant-librarian-chef
$ cd vagrant
$ vagrant up
$ vagrant ssh
$ cd [proj-name]
$ meteor run
```

After running the above commands you should be able to browse to http://locahost:3000/ and see your running Meteor app. Changes to files via the host machine will immediately be updated on the guest VM as well. Now get in there and build something awesometronic with Meteor!
