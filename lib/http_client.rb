HTTP_CLIENT_DIR = File.join(File.dirname(__FILE__), 'http_client')
$LOAD_PATH.unshift(HTTP_CLIENT_DIR) unless $LOAD_PATH.include?(HTTP_CLIENT_DIR)

require 'status'

if defined?(JRUBY_VERSION)
  JRUBY_HTTP_CLIENT_DIR = File.join(HTTP_CLIENT_DIR, 'jruby')
  VENDOR_DIR = File.expand_path(File.join(File.dirname(__FILE__), '..', 'vendor'))

  $LOAD_PATH.unshift(JRUBY_HTTP_CLIENT_DIR) unless $LOAD_PATH.include?(JRUBY_HTTP_CLIENT_DIR)
  $LOAD_PATH.unshift(VENDOR_DIR) unless $LOAD_PATH.include?(VENDOR_DIR)

  require 'java'
  require 'commons-logging-1.1.1'
  require 'commons-codec-1.4'
  require 'httpcore-4.1'
  require 'httpmime-4.1.1'
  require 'httpclient-4.1.1'
  require 'httpclient-cache-4.1.1'

  require 'client_configuration'
else
  MRI_HTTP_CLIENT_DIR = File.join(HTTP_CLIENT_DIR, 'mri')
  $LOAD_PATH.unshift(MRI_HTTP_CLIENT_DIR) unless $LOAD_PATH.include?(MRI_HTTP_CLIENT_DIR)

  require 'net/http'
  require 'cgi'
end

require 'methods'
require 'response'
require 'client'
