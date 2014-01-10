require 'pocketbeuter'
require 'helpers'
require 'spec_helper'
include WebMock::API

describe Pocketbeuter::CLI do
  before :each do
    @cli = Pocketbeuter::CLI.new
    $old_stderr = $stderr
    $old_stdout = $stdout
    $stderr = StringIO.new
    $stdout = StringIO.new
  end

  after :each do
    $stderr = $old_stderr
    $stdout = $old_stdout
  end

  describe '#createapp' do
    before do
      File.open(fixtures_path + "/createapp", File::RDWR | File::TRUNC | File::CREAT, 0600) do |f|
        f.write ""
      end
      @cli.config.path = fixtures_path + "/createapp"
    end
    it 'print instructions and set account_name, consumer_key and redirect_uri' do
      expect($stdout).to receive(:print)
      expect($stdin).to receive(:gets).and_return('\n')
      expect($stdout).to receive(:print).with("Enter account name [#{ENV['USER']}]: ")
      expect($stdin).to receive(:gets).and_return('foo')
      expect($stdout).to receive(:print).with('Enter consumer key: ')
      expect($stdin).to receive(:gets).and_return('foo1337')
      expect($stdout).to receive(:print).with('Enter redirect uri: ')
      expect($stdin).to receive(:gets).and_return('http://foo.bar')
      @cli.createapp
      expect(@cli.config.account_name).to match(/foo/)
      expect(@cli.config.consumer_key).to match(/foo1337/)
      expect(@cli.config.redirect_uri).to match(/http:\/\/foo.bar/)
    end
  end
  vcr_options = { :cassette_name => "authorize", :record => :new_episodes }
  describe '#authorize', :vcr => vcr_options do
    before do
      File.open(fixtures_path + "/createapp", File::RDWR | File::TRUNC | File::CREAT, 0600) do |f|
        f.write ""
      end
      @cli.config.path = fixtures_path + "/createapp"
      @cli.config.account_name = 'foo'
      @cli.config.consumer_key = 'foo1337'
      @cli.config.redirect_uri = 'foo1337'
    end
    it 'request code, access_token and username' do
      expect($stdout).to receive(:print)
      expect($stdin).to receive(:gets).and_return('\n')
      @cli.authorize
      expect(@cli.config.code).to match(/foobar42/)
      expect(@cli.config.access_token).to match(/barfoo42/)
      expect(@cli.config.username).to match(/joedoe/)
    end
  end
end

