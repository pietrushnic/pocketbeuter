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
    it 'return account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/multiple_accounts"
      expect(cfg['account'].keys).to match_array(['foo'])
    end
    it 'return options' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/options"
      expect(cfg['options'].keys).to match_array(['abc', 'cde'])
    end
  end

  describe '#account' do
    it 'return account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/multiple_accounts"
      expect(cfg.account.keys).to match_array(['foo'])
    end
  end

  describe '#account=' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
    end
    it 'set foo account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/emptyrc"
      cfg.account = {
        'foo' => {}
      }
      expect(cfg.account.keys).to match_array(['foo'])
    end
    it 'set empty foo account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/emptyrc"
      cfg.account = {
        'foo' => {}
      }
      expect(cfg.account.values[0]).to be_empty
    end
  end

  describe '#account_name' do
    it 'return account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/multiple_accounts"
      expect(cfg.account_name).to match(/foo/)
    end
  end

  describe '#account_name=' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
    end
    it 'return account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/emptyrc"
      cfg.account_name = 'foo'
      expect(cfg.account_name).to match(/foo/)
    end
  end

  describe '#[]=' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
    end
    it 'adds user account' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + '/emptyrc'
      cfg['account'] = {
        'foo' => {
          'consumer_key' => '1234-12345567889',
          'redirect_uri' => 'http://google.com'
        }
      }
      expect(cfg['account'].keys).to match_array(['foo'])
      expect(cfg['account']['foo'].keys).to match_array(['consumer_key', 'redirect_uri'])
    end
    it 'adds options' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + '/emptyrc'
      cfg['options'] = {
        'foo' => {
          'consumer_key' => '1234-12345567889',
          'redirect_uri' => 'http://google.com'
        }
      }
      expect(cfg['options'].keys).to match_array(['foo'])
      expect(cfg['options']['foo'].keys).to match_array(['consumer_key', 'redirect_uri'])
    end
  end

  describe '#redirect_uri' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
          'consumer_key' => '1234-12345567889',
          'redirect_uri' => 'http://google.com'
        }
      }
    end

    it 'returns redirect_uri for user foo' do
      expect(@cfg.redirect_uri).to match(/http:\/\/google.com/)
    end
  end

  describe '#redirect_uri=' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
        }
      }
    end

    it 'returns redirect_uri for user foo' do
      @cfg.redirect_uri = 'http://google.com'
      expect(@cfg.redirect_uri).to match(/http:\/\/google.com/)
    end
    it 'change redirect_uri for user foo' do
      @cfg.redirect_uri = 'http://google.com'
      @cfg.redirect_uri = 'http://gaagle.com'
      expect(@cfg.redirect_uri).to match(/http:\/\/gaagle.com/)
    end
  end

  describe '#consumer_key' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
          'consumer_key' => '1234-12345567889',
          'redirect_uri' => 'http://google.com'
        }
      }
    end

    it 'returns consumer_key for user foo' do
      expect(@cfg.consumer_key).to match(/1234-12345567889/)
    end
  end

  describe '#consumer_key=' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
        }
      }
    end

    it 'returns consumer_key for user foo' do
      @cfg.consumer_key = '1234-12345567889'
      expect(@cfg.consumer_key).to match(/1234-12345567889/)
    end
    it 'change consumer_key for user foo' do
      @cfg.consumer_key = '1234-12345567889'
      @cfg.consumer_key = '1234-12345567888'
      expect(@cfg.consumer_key).to match(/1234-12345567888/)
    end
  end

  describe '#access_token' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
          'access_token' => '1234-12345567889',
          'redirect_uri' => 'http://google.com'
        }
      }
    end

    it 'returns access_token for user foo' do
      expect(@cfg.access_token).to match(/1234-12345567889/)
    end
  end

  describe '#access_token=' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
        }
      }
    end

    it 'returns access_token for user foo' do
      @cfg.access_token = '1234-12345567889'
      expect(@cfg.access_token).to match(/1234-12345567889/)
    end
    it 'change access_token for user foo' do
      @cfg.access_token = '1234-12345567889'
      @cfg.access_token = '1234-12345567888'
      expect(@cfg.access_token).to match(/1234-12345567888/)
    end
  end

  describe '#code' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
          'code' => '1234-12345567889',
          'redirect_uri' => 'http://google.com'
        }
      }
    end

    it 'returns code for user foo' do
      expect(@cfg.code).to match(/1234-12345567889/)
    end
  end

  describe '#code=' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
        }
      }
    end

    it 'returns code for user foo' do
      @cfg.code = '1234-12345567889'
      expect(@cfg.code).to match(/1234-12345567889/)
    end
    it 'change code for user foo' do
      @cfg.code = '1234-12345567889'
      @cfg.code = '1234-12345567888'
      expect(@cfg.code).to match(/1234-12345567888/)
    end
  end

  describe '#username' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
          'username' => '1234-12345567889',
          'redirect_uri' => 'http://google.com'
        }
      }
    end

    it 'returns username for user foo' do
      expect(@cfg.username).to match(/1234-12345567889/)
    end
  end

  describe '#username=' do
    before do
      File.open(fixtures_path + '/emptyrc', File::RDWR | File::CREAT | File::TRUNC, 600) do |f|
        f.write ''
      end
      @cfg = Pocketbeuter::ConfigFile.instance
      @cfg.path = fixtures_path + '/emptyrc'
      @cfg['account'] = {
        'foo' => {
        }
      }
    end

    it 'returns username for user foo' do
      @cfg.username = '1234-12345567889'
      expect(@cfg.username).to match(/1234-12345567889/)
    end
    it 'change username for user foo' do
      @cfg.username = '1234-12345567889'
      @cfg.username = '1234-12345567888'
      expect(@cfg.username).to match(/1234-12345567888/)
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
    before do
      File.open(fixtures_path + "/emptyrc", File::RDWR | File::TRUNC | File::CREAT, 0600) do |f|
        f.write ""
      end
    end
    it 'when file exist' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/multiple_accounts"
      expect(cfg.load_config['account']['foo'].keys).to include('consumer_key','redirect_uri')
    end
    it 'when file exist but is empty' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/emptyrc"
      expect(cfg.load_config['account'].keys).to be_empty
    end
    it 'when file doesn not exist' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = fixtures_path + "/foo"
      expect(cfg.load_config['account'].keys).to be_empty
    end
    it 'when file path is empty' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = ''
      expect(cfg.load_config['account'].keys).to be_empty
    end
  end

  describe '#empty?' do
    it 'return default_config' do
      cfg = Pocketbeuter::ConfigFile.instance
      cfg.path = ''
      expect(cfg.empty?).to be_true
    end
  end
end
