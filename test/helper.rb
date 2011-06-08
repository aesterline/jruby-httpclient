TEST_DIR = File.dirname(__FILE__)
LIB_DIR = File.join(TEST_DIR, '..', 'lib')

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'

$LOAD_PATH.unshift(TEST_DIR) unless $LOAD_PATH.include?(TEST_DIR)
$LOAD_PATH.unshift(LIB_DIR) unless $LOAD_PATH.include?(LIB_DIR)

require 'http_client'
require 'webrick'
require 'http_test_server'

HTTP::TestServer.start_server