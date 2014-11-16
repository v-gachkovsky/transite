require 'iconv'

class FileWorker
  attr_reader :files

  def initialize(options)
    @format = options[:format]
    @dir    = options[:dir]
    @files  = []
    find_files(@dir, @format)
  end

  def find_files(directory, format)
    abort "#{directory} is not a directory" unless File.directory?(directory)

    dir = Dir.new directory
    dir.each do |file|
      next if file =~ /^\.{1,2}$/
      if File.directory?("#{directory}/#{file}")
        downdir = "#{directory}/#{file}"
        find_files(downdir, format)
      else
        @files << "#{directory}/#{file}" if file =~ /\.(html|htm)$/i 
      end
    end
  end

  def read_file(filename, codepage)
    to_utf(File.open(filename, 'r') { |file| File.read(file) }, codepage)
  end

  def save_to_file(filename, text)
    File.open(filename, 'w') { |file| file.puts text }
    $log.proccess_logging(filename)
  end

  def to_utf(content, codepage)
    return content if codepage.downcase == 'utf-8'
    begin
      Iconv.conv("utf-8", "#{codepage}", content)
    rescue
      abort "Invalid encoding is specified"
    end
  end

end