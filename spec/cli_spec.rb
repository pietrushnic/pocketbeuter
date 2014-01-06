require 'pocketbeuter'
require 'helpers'
require 'spec_helper'

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

  describe '#create_app' do
    before do
      File.open(fixtures_path + "/emptyrc", File::RDWR | File::TRUNC | File::CREAT, 0600) do |f|
        f.write ""
      end
      @cli.config.path = fixtures_path + "/emptyrc"
    end
    it 'print instructions and get consumer_key and redirect_uri' do
      expect($stdout).to receive(:print).exactly(10).times
      expect($stdin).to receive(:gets).and_return('n')
      expect($stdout).to receive(:print).with('Enter consumer key:')
      expect($stdin).to receive(:gets).and_return('foo1337')
      expect($stdout).to receive(:print).with('Enter redirect uri:')
      expect($stdin).to receive(:gets).and_return('http://foo.bar')
      $old_stdout.puts "config: #{@cli.config.default_account}"
      @cli.createapp
      expect(@cli.config.consumer_key).to match(/foo1337/)
      expect(@cli.config.redirect_uri).to match(/http:\/\/foo.bar/)
    end
  end
end

