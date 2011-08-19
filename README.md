Railsyard CMS
=============

This is a quite stable release of the complete rewrite of Railsyard CMS.

The public themes are still missing, but the backend is working. A couple of public themes will come soon.

There are also a lot of feature missing and tests coverage is near zero (shame on me).


Features
--------
* hierarchy organized pages - indipendently for every language
* multilanguage frontend and backend
* reserved pages and articles
* pretty urls and other seo-friendly features
* drop-in themes
* drop-in snippets plugins
* different user roles
* backend heavily based on drag & drop
* built with Ruby on Rails
	
To-do
-----
* decent public themes
* [admin] some i18n backend labels
* caching
* queries optimization - memoization
* blogging features to be completed
* comments on articles
* comments moderation and akismet/captcha integration
* previews
* a lot of documentation
* a lot of tests
* github wiki
* update to Rails 3.1 when all the gems we are using became compatible

Requirements:
-------------
* Ruby 1.9.2 or 1.8.7
* Rails 3.0.9
* Some gems - check config/environment.rb

Installation
------------
We really suggest the use of Ruby RVM and Ruby 1.9.2

    run 'rvm install ruby-1.9.2-p290'
    run 'rvm use ruby-1.9.2-p290'
    run 'rvm gemset create "railsyard"'
    run 'git clone https://github.com/cantierecreativo/railsyardcms.git'
    run 'cd railsyardcms'
    run 'gem install rails -v="3.0.9"'
    run 'gem install bundler'
    run 'bundle install'
    edit config/database.yml according to your configuration
    run 'rake db:migrate'

Using with Ruby 1.8.7
---------------------
Comment out line 3 and 4 inside /config/boot.rb

    require 'yaml'
    YAML::ENGINE.yamler= 'syck'
  
Update .rvmrc according to your Ruby version

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
Drop themes in /themes

Take a look to the current themes to understand how they work. They are placed in /themes/.

There is a yaml config file for configuring some settings in every theme.

We are using the [themes_for_rails](https://github.com/lucasefe/themes_for_rails) gem for managing themes, so take a look to the gem's documentation too.

*To-do full documentation in the wiki*
    
Snippets plugins
----------------
Snippets are implemented using Rails Cells

Drop them in /app/cells

Take a look to the current snippets to understand how they work. They are placed in /app/cells/.

There is a yaml config file for configuring some settings in every snippet.

We are using the [cells](https://github.com/apotonick/cells) gem for making the snippets, so take a look to the gem's documentation too.

*To-do full documentation in the wiki*

	
Credits
-------
Funded and developed by [Cantiere Creativo](http://www.cantierecreativo.net)

All the credits to the respective owners/devopers of gems/plugins/scripts used.

The big boys
------------
* [Silvio Relli](http://www.relli.org) - project manager and main developer
* [Matteo Papadopoulos](http://www.basictrading.biz) - backend and public themes designer

Contributors
------------
If you contributed to this project committing even a single bit feel free to add your name here!

* [Paul Spieker](https://github.com/spieker)
	
