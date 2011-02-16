require 'rake'
require 'rake/testtask'

$:.unshift 'lib'
#require './init.rb'

desc 'Default: run unit tests.'
task :default => :test

desc 'Run all unit tests.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/test_*.rb'
  t.verbose = true
end
