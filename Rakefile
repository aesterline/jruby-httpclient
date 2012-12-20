# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "jruby-httpclient"
  gem.homepage = "http://github.com/aesterline/jruby-httpclient"
  gem.license = "Apache 2.0"
  gem.summary = %Q{A thin wrapper around the Apache HttpClient}
  gem.description = %Q{An HTTP client designed for use with JRuby in a threaded environment}
  gem.email = "adam@esterlines.com"
  gem.authors = ["Adam Esterline", "Aaron Spiegel"]
  gem.platform = Gem::Platform::JAVA
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  puts Dir.pwd
  test.libs << 'lib' << 'test'
  test.test_files = FileList["#{Dir.pwd}/test/**/test_*.rb"]
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "http_client #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
