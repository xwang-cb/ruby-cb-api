require 'cb'
require 'webmock/rspec'
require 'byebug'

WebMock.disable_net_connect!(allow: %r{codeclimate.com})
