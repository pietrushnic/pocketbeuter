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
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::CONFIG_NAME}"
      expect(cfg['foo'].keys).to include('consumer_key','redirect_uri')
    end
  end

  describe '#[]=' do
    it 'adds user account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = '/tmp/.pocketbeuterrc'
      cfg['accounts'] = {
        'foo' => {
          :consumer_key => '1234-12345567889',
          :redirect_uri => 'http://google.com'
        }
      }
      expect(cfg['foo'].keys).to match_array([:consumer_key, :redirect_uri])
    end
  end

  describe '#account' do
    it 'returns account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::CONFIG_NAME}"
      expect(cfg.accounts.keys).to match_array(['foo'])
    end
  end

  describe '#consumer_key' do
    it 'returns consumer_key' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::CONFIG_NAME}"
      expect(cfg.consumer_key('foo')).to match(/77777-8647bd0425d5a4541e07dfcf/)
    end
  end

  describe '#redirect_uri' do
    it 'returns redirect_uri' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::CONFIG_NAME}"
      expect(cfg.redirect_uri('foo')).to match(/https:\/\/github.com/)
    end
  end

  describe '#set_code' do
    it 'save request_token to config file' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::CONFIG_NAME}"
      cfg.set_code('foo', '13ea4f22-1111-d26a-58fe-77777')
      expect(cfg.get_code('foo')).to match(/13ea4f22-1111-d26a-58fe-77777/)
    end
  end

  describe '#set_token' do
    it 'save access_token to config file' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::CONFIG_NAME}"
      cfg.set_token('foo', '13ea4f22-b153-d26a-58fe-77777')
      expect(cfg.get_token('foo')).to match(/13ea4f22-b153-d26a-58fe-77777/)
    end
  end
end
