Railsyard CMS
=============

That's just an **incomplete** but quite stable developer preview release of Railsyard CMS.

The public default theme is still missing some things, but the backend is functional.

A better documentation coming soon..

Features
--------
* hierarchy organized pages
* multilanguage frontend and backend
* snippets attachable to 6 different page zones
* articles
* reserved pages and articles
* categories
* comments
* themes
* pretty urls
* built with Ruby on Rails
	
To-do
-----
* finishing themes support
* porting to Rails 3
* moving from Prototype to jQuery
* moving from Embedded Actions to Cells
* better support for Ruby 1.9.2
* caching
* managing available languages
* queries optimization - memoization
* comments moderation and akismet integration
* renaming categories
* refactoring snippets modeling
* previews
* one more example theme
* better user section in backend
* a lot of documentation
* a lot of tests

Raquirements:
-------------
* Ruby 1.8.7
* Rails 2.3.11
* Some gems - check config/environment.rb

Installation
------------
	run 'git clone https://github.com/cantierecreativo/railsyardcms.git'
	run 'gem install rails -v="2.3.11" '
	run 'cd railsyard'
	edit config/database.yml according to your configuration
	run 'rake gems:install'
	run 'rake db:migrate'
	
Usage
-----
*Admin interface* is on yoursite.tld/admin
	username: superadmin
	password: superadmin
		
Credits
-------
Funded and developed by [Cantiere Creativo](http://www.cantierecreativo.net)

All the credits to the respective owners/devopers of gems/plugins/scripts used.

Contributors
------------
* [Silvio Relli](http://www.relli.org) - project manager and main coder
* Marco Zampetti - zaorunner@gmail.com - backend UI designer
* [Matteo Papadopoulos](http://www.basictrading.biz) - logo and default theme designer
	
