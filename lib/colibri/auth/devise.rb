require 'colibri/core'
require 'devise'
require 'devise-encryptable'
require 'cancan'

Devise.secret_key = SecureRandom.hex(50)

module Colibri
  module Auth
    mattr_accessor :default_secret_key

    def self.config(&block)
      yield(Colibri::Auth::Config)
    end
  end
end

Colibri::Auth.default_secret_key = Devise.secret_key

require 'colibri/auth/engine'
