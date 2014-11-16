require 'net/http'
require 'json'

class Translator
  attr_reader :options, :format, :lang

  def initialize(options)
    @options = 1
    @format  = options[:format]
    @lang    = options[:lang]
  end

  # data must contain hash with keys: key, text
  def translate(data)
    result = to_yandex(data)
    
    begin
      result = JSON.parse(result.body, symbolize_names: true)
    rescue
      { code: 422 }
    end
  end

  private

  def full_params(data)
    data.merge!(options: @options, format: @format, lang: @lang)
  end

  def to_yandex(data)
    yandex_api = URI("https://translate.yandex.net/api/v1.5/tr.json/translate")
    Net::HTTP.post_form(yandex_api, full_params(data))
  end

end