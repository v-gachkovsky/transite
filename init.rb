require_relative 'lib/logger'
require_relative 'lib/translator'
require_relative 'lib/file_worker'
require_relative 'lib/yandex_keys'

unless ARGV.size == 3
  abort "Transite 1.1.0" if ARGV[0] =~ /(:?^-v$)|(:?^--version$)/
  abort "Usage: #{$0} path/to/dir/with/files codepage lang-lang"
end

args = { codepage: ARGV[1],
         format: 'html', 
         lang: ARGV[2],
         dir: ARGV[0].gsub(/\/$/, '') }

yandex_keys = YandexKeys.new
yandex      = Translator.new(args)
files       = FileWorker.new(args)
log         = Logger.new

log.start_logging

files.files.sort.each do |file|
  data = { key: yandex_keys.key, text: files.read_file(file, args[:codepage]) }
  result = yandex.translate(data)
  files.save_to_file(file, result)
end