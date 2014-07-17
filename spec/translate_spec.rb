require 'rspec'
require_relative '../lib/translate'
require_relative '../lib/yandex_keys'

trans = Translate.new(format: 'plain', lang: 'en-ru')
key   = YandexKeys.new

describe Translate do
  it "Text is translated" do
    data = { text: 'This is a test',
             key:   key.key }
                
    translated = trans.translate(data)
    translated.should == 'Это тест'
  end
end