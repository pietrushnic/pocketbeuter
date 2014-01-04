require 'pocketbeuter'
require 'helpers'

describe Pocketbeuter::ConfigFile do
  it 'is a singleton' do
    expect(Pocketbeuter::ConfigFile).to be_a Class
    expect do
      Pocketbeuter::ConfigFile.new
    end.to raise_error(NoMethodError, /private method `new' called/)
  end

  describe '#[]' do
    it 'returns user account' do
      config = Pocketbeuter::ConfigFile.instance
      config.path = fixtures_path + "/#{Pocketbeuter::CONFIG_NAME}"
      expect(config['foo'].keys).to match_array(['consumer_key','redirect_uri'])
      expect(config['bar'].keys).to match_array(['consumer_key','redirect_uri'])
    end
  end
end
