require 'pocketbeuter'
require 'helpers'

describe Pocketbeuter::ConfigFile do
  after :each do
    Pocketbeuter::ConfigFile.instance.reset
  end

  it 'is a singleton' do
    expect(Pocketbeuter::ConfigFile).to be_a Class
    expect do
      Pocketbeuter::ConfigFile.new
    end.to raise_error(NoMethodError, /private method `new' called/)
  end

  describe '#[]' do
    it 'returns user account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
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

  describe '#accounts' do
    it 'returns accounts' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      expect(cfg.accounts.keys).to match_array(['foo'])
    end
  end

  describe '#consumer_key' do
    it 'returns consumer_key for user foo' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      expect(cfg.consumer_key('foo')).to match(/77777-8647bd0425d5a4541e07dfcf/)
    end
    it 'returns consumer_key for default_account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      cfg.set_default_account = 'foo'
      expect(cfg.consumer_key).to match(/77777-8647bd0425d5a4541e07dfcf/)
    end
    it 'returns consumer_key for invalid default_account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      cfg.set_default_account = 'some_invalid_account'
      expect do
        cfg.consumer_key
      end.to raise_error(NoMethodError, /undefined method/)
      cfg.set_default_account = 'foo'
    end
  end

  describe '#redirect_uri' do
    it 'returns redirect_uri' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      expect(cfg.redirect_uri('foo')).to match(/https:\/\/github.com/)
    end
    it 'returns redirect_uri for default_account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      cfg.set_default_account = 'foo'
      expect(cfg.redirect_uri).to match(/https:\/\/github.com/)
    end
    it 'returns redirect_uri for invalid default_account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      cfg.set_default_account = 'some_invalid_account'
      expect do
        cfg.redirect_uri
      end.to raise_error(NoMethodError, /undefined method/)
      cfg.set_default_account = 'foo'
    end
  end

  describe '#set_code' do
    it 'save request_token to config file' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      cfg.set_code('foo', '13ea4f22-1111-d26a-58fe-77777')
      expect(cfg.get_code('foo')).to match(/13ea4f22-1111-d26a-58fe-77777/)
    end
  end

  describe '#set_token' do
    it 'save access_token to config file' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      cfg.set_token('foo', '13ea4f22-b153-d26a-58fe-77777')
      expect(cfg.get_token('foo')).to match(/13ea4f22-b153-d26a-58fe-77777/)
    end
  end

  describe '#path' do
    it 'get default path' do
      expect(Pocketbeuter::ConfigFile.instance.path).to match(File.join(File.expand_path('~'), Pocketbeuter::ConfigFile::CONFIG_NAME))
    end
  end

  describe '#path=' do
    it 'set path' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      expect(cfg.path).to match(fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}")
    end
  end

  describe '#load_config' do
    it 'when file exist' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      expect(cfg.load_config['accounts']['foo'].keys).to include('consumer_key','redirect_uri')
    end
    it 'when file doesn not exist' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/foo"
      expect(cfg.load_config['accounts'].keys).to be_empty
    end
    it 'when file path is empty' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = ''
      expect(cfg.load_config['accounts'].keys).to be_empty
    end
  end

  describe '#empty?' do
    it 'return default_config' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = ''
      expect(cfg.empty?).to be_true
    end
  end

  describe '#default_account' do
    it 'return default_account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = ''
      expect(cfg.default_account).to match(ENV['USER'])
    end
  end

  describe '#set_default_account' do
    it 'set and save default_account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/#{Pocketbeuter::ConfigFile::CONFIG_NAME}"
      cfg.set_default_account  = 'foobar1'
      expect(cfg.default_account).to match(/foobar1/)
      cfg.set_default_account  = 'foobar'
      expect(cfg.default_account).to match(/foobar/)
    end
  end
end
