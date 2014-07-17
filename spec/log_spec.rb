require 'rspec'
require_relative '../lib/log'
require_relative '../lib/yandex_keys'

log = Log.new
key = YandexKeys.new

describe Log do
  it "Class Log write a row about start running program in log file" do
    File.delete(log.work_log) if File.exist?(log.work_log)
    log.start_logging
    
    start_row = ''
    File.open(log.work_log, 'r') { |file| start_row = File.read(file).chomp }
    start_row.should =="#{log.current_time} - Translate began"
  end

  it "Class Log write a row about big file in log file" do
    filename = '../text/bigfile.html'
    bigfilelog = ''

    File.delete(log.bigfiles_log) if File.exist?(log.bigfiles_log)
    log.bigfile_logging(filename)
    File.open(log.bigfiles_log, 'r') { |file| bigfilelog = File.read(file).chomp }
    bigfilelog.should == "#{log.current_time} - #{filename}: File is very big"
  end

  it "Class Log write a row in log file if key broken" do
    File.delete(log.keys_log) if File.exist?(log.keys_log)
    key.get_key
    File.open(log.keys_log, 'r') { |file| brokenkeyslog = File.read(file).chomp }
    brokenkeyslog.should =~ /#{log.current_time} - trnsl.1.1.+ key used/
  end
end