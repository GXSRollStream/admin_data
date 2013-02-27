require 'admin_data/rails_version_check'
require 'will_paginate'

module AdminData
  extend ActiveSupport::Autoload

  LIBPATH = File.dirname(__FILE__)

  autoload :Configuration
  autoload :Util
  autoload :Config
  autoload :ActiveRecordUtil
  autoload :SetupConfig
  autoload :DateUtil
  autoload :Authenticator
  autoload :Search
  autoload :Analytics
  autoload :BuildKlasses

  include SetupConfig

end

require 'admin_data/railtie'
require 'admin_data/exceptions'
