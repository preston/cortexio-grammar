#!/usr/bin/env rake
require "bundler/gem_tasks"
 
require 'rake/testtask'
 
Rake::TestTask.new do |t|
  t.libs << 'lib/cortexio-grammar'
  t.test_files = FileList['test/lib/cortexio-grammar/*_test.rb']
  t.verbose = true
end
 
task :default => :test
