Railsyard CMS
=============

This is rushed, **incomplete** but quite stable release of the complete rewrite of Railsyard CMS.

The public themes are still missing, but the backend is working.

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
* reserved pages
* built with Ruby on Rails
	
To-do
-----
* [admin] users management (!!urgent!!)
* [admin] i18n backend labels (now hardcoded)
* [admin] managing available languages
* caching
* queries optimization - memoization
* blogging features - articles, categories and comments
* comments moderation and akismet integration
* previews
* a lot of documentation
* a lot of tests
* github wiki

Raquirements:
-------------
* Ruby 1.9.2-p290
* Rails 3.0.9
* Some gems - check config/environment.rb

Installation
------------
    We really suggest the use of Ruby RVM
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
	
Usage
-----
Admin interface is on yoursite.tld/admin
username: admin@example.com
password: password

Themes
------
Drop themes in /themes
*To-do full documentation*
    
Snippets plugins
----------------
Snippets are implemented using Rails Cells
Drop them in /app/cells
*To-do full documentation*

	
Credits
-------
Funded and developed by [Cantiere Creativo](http://www.cantierecreativo.net)

All the credits to the respective owners/devopers of gems/plugins/scripts used.

Contributors
------------
* [Silvio Relli](http://www.relli.org) - project manager and main coder
* [Matteo Papadopoulos](http://www.basictrading.biz) - v2 backend and frontend designer
* Marco Zampetti - zaorunner@gmail.com - v1 backend designer

	
