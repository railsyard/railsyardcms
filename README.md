Railsyard CMS
=============
![Railsyard CMS](http://railsyardcms.org/images/logo_big.jpg "Railsyard CMS")

[![Build Status](https://secure.travis-ci.org/cantierecreativo/railsyardcms.png?branch=master)](http://travis-ci.org/cantierecreativo/railsyardcms)

This is a complete rewrite of Railsyard, a content management system SEO oriented and heavily based on components.


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

	
To-do
-----
* at least one more public theme
* caching
* comments moderation in backend
* previews of pages and articles
* a lot of documentation
* a lot of tests
* github wiki
* update to Rails 3.1 when all the gems we are using became compatible [in progress]

Requirements:
-------------
* Ruby 1.9.2 or 1.8.7
* Rails 3.0.11
* MySQL, PostgreSQL or SQLite
* Some gems - check Gemfile

Installation
------------
We really suggest the use of Ruby RVM and Ruby 1.9.2

    run 'rvm install ruby-1.9.2-p290'
    run 'rvm use ruby-1.9.2-p290'
    run 'rvm gemset create "railsyard"'
    run 'git clone https://github.com/cantierecreativo/railsyardcms.git'
    run 'cd railsyardcms'
    run 'gem install rails -v="3.0.11"'
    run 'gem install bundler'
    run 'bundle install'
    edit config/database.yml according to your configuration
    run 'rake ry:init'
    run 'rake db:seed' to load some example pages

Usage
-----
Admin interface is on yoursite.tld/admin

username: admin@example.com

password: changeme

Adding a new language
---------------------
Add a language to the $AVAILABLE_LANGUAGES variable inside /config/application.rb, for example 'de'.

Add a translated I18n yaml file inside /config/locales/, look at en.yml for reference.

Run the rails console and execute:

    lang = 'de'
    first_theme = Theme.all.first.short
    first_layout = Layout.all(first_theme).first.filename
    root = Page.create :title => lang, :pretty_url => lang, :lang => lang
    root.children.create :title => "Home #{lang}", :pretty_url => "home_#{lang}", :lang => lang, :visible_in_menu => true, :reserved => false, :published => true, :position => 1, :layout_name => first_layout, :publish_at => Time.now, :meta_title => "Home #{lang}", :meta_description => "Home #{lang}"


Themes
------

Take a look to the current themes to understand how they work. They are placed in /themes/.

There is a yaml config file for configuring some settings in every theme.

We are using the [themes_for_rails](https://github.com/lucasefe/themes_for_rails) gem for managing themes, so take a look to the gem's documentation too.

*To-do full documentation in the wiki*
    
Snippets plugins
----------------
Snippets are implemented using Rails Cells


Take a look to the current snippets to understand how they work. They are placed in /app/cells/.

There is a yaml config file for configuring some settings in every snippet.

We are using the [cells](https://github.com/apotonick/cells) gem for making the snippets, so take a look to the gem's documentation too.

*To-do full documentation in the wiki*


Testing
-------
Tests are written using [Cucumber](http://cukes.info/)

To launch all the tests symply run
    cucumber
inside the Railsyard directory.

To launch a single feature run
    cucumber --name "Manage pages admin panel and check effects on public side"
giving the name of the feature.

Changelog
---------
2011.12.05 - version HEAD   
* changed the html structure of menu cell
 
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

Railsyard exists mainly thanks to the community.
 

The big boys
------------
* [Silvio Relli](http://www.relli.org) - project manager and main developer
* [Matteo Papadopoulos](http://www.basictrading.biz) - backend and public themes designer

Contributors
------------
If you contributed to this project committing even a single bit feel free to add your name here!

* [Paul Spieker](https://github.com/spieker) - our first and very active contributor
	
