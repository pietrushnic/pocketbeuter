require 'pocketbeuter'
require 'helpers'
require 'spec_helper'

describe Pocketbeuter::CLI do
  before :each do
    @cli = Pocketbeuter::CLI.new
  end
  describe '#authorize' do
    #use_vcr_cassette 'request_access_token'
    #it 'request access_token' do
    #  @cli.authorize
    #end
  end
end

