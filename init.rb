require_relative 'lib/logger'
require_relative 'lib/translator'
require_relative 'lib/file_worker'
require_relative 'lib/yandex_keys'

require 'future_proof'

unless ARGV.size == 3
  if ARGV[0] =~ /(:?^-v$)|(:?^--version$)/
    abort "Transite 1.1.0 @ 17.10.2014\nby Vladimir Gachkovsky v.gachkovsky@gmail.com" 
  end
  puts "Usage: #{$0} path/to/dir/ [codepage] [lang-lang]"
  puts "\ncodepage: Most popular utf-8, windows-1251..."
  puts "lang-lang: See https://tech.yandex.ru/translate/doc/dg/concepts/langs-docpage/"
  abort
end

args = { 
          codepage: ARGV[1],
          format: 'html', 
          lang: ARGV[2],
          dir: ARGV[0].gsub(/\/$/, '') 
       }

$log         = Logger.new
$yandex_keys = YandexKeys.new
yandex       = Translator.new(args)
worker       = FileWorker.new(args)

def check_result(result)
  # 413 # Превышен максимально допустимый размер текста
  # 422 # Текст не может быть переведен
  # 501 # Заданное направление перевода не поддерживается

  case result[:code]
  when 200
    0
  when 400..405
    1
  when 413
    2
  when 422
    3
  when 501
    4
  end
end

def only_text(result)
  result[:text].first
end

$log.start_logging(args)

thread_pool = FutureProof::ThreadPool.new(8)

worker.files.sort.each do |f|
  thread_pool.submit f do |file|
    data   = { key: $yandex_keys.key, text: worker.read_file(file, args[:codepage]) }
    result = yandex.translate(data)
    
    result_code = check_result(result)
    
    if result_code == 0
      worker.save_to_file(file, only_text(result))
    
    elsif result_code == 1
      $yandex_keys.get_key
      redo
  
    elsif result_code == 2
      $log.bigfile_logging(file)
      next
      
    else
      $log.error_logging(file)
      next
  
    end
  end
end

thread_pool.perform
begin
  thread_pool.values
rescue

end