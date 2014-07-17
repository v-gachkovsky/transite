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
    result = send(data)

    return result unless result.is_a?(Net::HTTPOK)
    result = JSON.parse(result.body, symbolize_names: true)
    only_text(result)
  end

  private

  def full_params(data)
    data.merge!(options: @options, format: @format, lang: @lang)
  end

  def only_text(result)
    result[:text].first
  end

  def send(data)
    yandex_api = URI("https://translate.yandex.net/api/v1.5/tr.json/translate")
    Net::HTTP.post_form(yandex_api, full_params(data))
  end

end