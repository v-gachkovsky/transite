require 'rspec'
require_relative '../lib/yandex_keys'

key = YandexKeys.new

describe YandexKeys do
  it "yandex_keys file is exists!" do
    File.should be_exist('yandex_keys')
  end

  it "yandex_keys.txt file is read" do
    key.keys.should_not be_empty
  end

  it "Yandex key is confirmed" do
    key.get_key
    key.key.should_not be_empty
  end

  it "Yandex key is changed" do
    current_key = key.key
    key.get_key
    key.key.should_not be_equal current_key
  end
end