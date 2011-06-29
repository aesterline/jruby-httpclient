HTTP_CLIENT_DIR = File.join(File.dirname(__FILE__), 'http_client')
VENDOR_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor'))

$LOAD_PATH.unshift(HTTP_CLIENT_DIR) unless $LOAD_PATH.include?(HTTP_CLIENT_DIR)
$LOAD_PATH.unshift(VENDOR_DIR) unless $LOAD_PATH.include?(VENDOR_DIR)

require 'java'
require 'commons-logging-1.1.1'
require 'commons-codec-1.4'
require 'httpcore-4.1'
require 'httpmime-4.1.1'
require 'httpclient-4.1.1'
require 'httpclient-cache-4.1.1'

require 'client_configuration'
require 'response'
require 'methods'
require 'client'
