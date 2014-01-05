require 'pocketbeuter'
require 'helpers'

describe Pocketbeuter::Pocket do
  before :each do
    @pocket = Pocketbeuter::Pocket.new
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
    it 'print instructions and get consumer_key and redirect_uri' do
      expect($stdout).to receive(:puts)
    end
  end
end
