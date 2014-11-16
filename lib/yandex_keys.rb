class YandexKeys
  attr_accessor :keys, :key

  def initialize
    @keys = []
    load_keys
    get_key
  end

  def get_key
    @key = @keys.shift
    $log.key_logging(@key)
  end

  private

  def load_keys
    File.open('yandex_keys', 'r') do |file|
      file.each { |key| @keys << key.chomp }
    end
  end

end