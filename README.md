Railsyard CMS
=============
![Railsyard CMS](http://railsyardcms.org/images/logo_big.jpg "Railsyard CMS")

This is a complete rewrite of Railsyard, a content management system heavily based on components and focused on easy theming and customization.

[![Build Status](https://secure.travis-ci.org/cantierecreativo/railsyardcms.png?branch=master)](http://travis-ci.org/cantierecreativo/railsyardcms)


Features
--------
* hierarchy organized pages
* runs on Heroku
* extremely easy theming
* multilanguage frontend and backend (actually English, Italian and German)
* different and independent pages for each language
* editing both from backend and directly from frontend
* blogging features with articles and comments
* user roles
* reserved pages and articles
* pretty urls and other seo-friendly features
* drop-in themes
* drop-in snippets plugins (using Rails Cells)
* Rails mountable engines support for heavy modification plugins 
* backend heavily based on drag & drop
* built with Ruby on Rails

Requirements:
-------------
* Ruby 1.9.2 or 1.8.7
* Rails 3.0.11
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
    run `gem install rails -v="3.0.11"`
    run `gem install bundler`
    run `bundle install`
    edit config/database.yml according to your configuration
    run `rake ry:init`
    run `rake db:seed` to load some example pages

Usage
-----
Admin interface is on yoursite.tld/admin

username: admin@example.com

password: changeme

Changelog
---------
2011.01.16 - version 0.3
* major changes and improvements in Cells controllers 
* changed the html structure of menu Cell
* decent tests coverage
* mailer
* many bugs fixed
 
2011.12.03 - version 0.2.1   
* Revisited admin forms
 
2011.12.02 - version 0.2.0   
* Comments on Articles   
* Attachment snippet with drag&drop of files (Gmail style)   
* Gallery snippet
  
2011.11.08 - version 0.1.0   
* First quite fully featured release

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
