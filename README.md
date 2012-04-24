Railsyard CMS
=============
![Railsyard CMS](http://railsyardcms.org/images/logo_big.jpg "Railsyard CMS")

This is a complete rewrite of Railsyard, a content management system heavily based on components and focused on easy theming and customization.

[![Build
Status](https://secure.travis-ci.org/cantierecreativo/railsyardcms.png?branch=master)](http://travis-ci.org/cantierecreativo/railsyardcms)

(PS: Looking for the new version? https://github.com/cantierecreativo/railsyard-backend)


Features
--------
* Hierarchy organized pages
* Runs on Heroku
* Extremely easy theming
* Multilanguage frontend and backend (actually English, Italian and German)
* Different and independent pages for each language
* Editing both from backend and directly from frontend
* Blogging features with articles and comments
* User roles
* Reserved pages and articles
* Pretty urls and other seo-friendly features
* Drop-in themes
* Drop-in snippets plugins (using Rails Cells)
* Rails mountable engines support for heavy modification plugins
* Backend heavily based on drag & drop
* Built with Ruby on Rails

Requirements:
-------------
* Ruby 1.9.3, 1.9.2 or 1.8.7
* Rails 3.2.1
* MySQL, PostgreSQL or SQLite
* Some gems - check Gemfile

Installation
------------
We really suggest the use of Ruby RVM and Ruby 1.9.2

run `rvm install ruby-1.9.2-p290`
run `rvm use ruby-1.9.2-p290`
run `rvm gemset create "railsyard"`
run `git clone https://github.com/cantierecreativo/railsyardcms.git`
run `cd railsyardcms`
run `gem install bundler`
run `bundle install`
edit config/database.yml according to your configuration
run `rake ry:init`
run `rake ry:example` to load some example pages

Usage
-----
Admin interface is on `yoursite.tld/admin`
Username: `admin@example.com`
Password: `changeme`

Documentation wiki
------------------
Take a look at the [Wiki](https://github.com/cantierecreativo/railsyardcms/wiki) for the full documentation.

Credits
-------
Funded and developed by [Cantiere Creativo](http://www.cantierecreativo.net)

All the credits to the respective owners/developers of gems/plugins/scripts used.

Railsyard exists mainly thanks to the Ruby/Rails community.


The big boys
------------
* [Silvio Relli](http://www.relli.org) - project manager and main developer
* [Matteo Papadopoulos](http://www.basictrading.biz) - backend and public themes designer

Contributors
------------
If you contributed to this project committing even a single bit feel free to add your name here!

* [Paul Spieker](https://github.com/spieker) - our first and very active contributor
