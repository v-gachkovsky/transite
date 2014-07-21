class Logger
  attr_reader :error_log, :work_log, :keys_log, :bigfiles_log
  
  def initialize
    @bigfiles_log = 'log/bigfiles.log'
    @error_log    = 'log/error.log'
    @work_log     = 'log/work.log'
    @keys_log     = 'log/keys.log'
  end

  def current_time
    Time.new.strftime('%d-%m-%Y %H:%M')
  end

  def start_logging(args)
    message = "\n#{current_time} - Translate began with params "
    args.each { |k, v| message << "#{k.to_s}: #{v} " }
    write_to_log(@work_log, message)
  end

  # log_methods = { proccess:  [@work_log, 'Translate complete'], 
  #                 bigfile: [@bigfiles_log, 'File is very big'], 
  #                 error: [@error_log, 'Error'], 
  #                 key: [@keys_log, 'key used'] }

  # log methods
  log_methods = { proccess:  ['log/work.log',     'Translate complete'], 
                  bigfile:   ['log/bigfiles.log', 'File is very big'], 
                  error:     ['log/error.log',    'Error'], 
                  key:       ['log/keys.log',     'key used'] }                  

  log_methods.each do |name, opts|
    define_method("#{name.to_s}_logging") do |arg|
      message = "#{current_time} - #{arg}: #{opts[1]}"
      
      puts message
      write_to_log(opts[0], message)
    end
  end

  private

  def write_to_log(filename, message)
    File.open(filename, "a") { |log| log.puts message.gsub('../', '')}
  end

end