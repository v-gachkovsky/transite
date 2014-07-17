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

    # work_log methods
  def start_logging
    message = "#{current_time} - Translate began"
    open_log(@work_log, message)
  end

  log_methods = %w! proccess bigfile error key !

  log_methods.each do |name|
    define_method("#{name}_logging") do |arg|
      case name
        when 'bigfile'
          message = "#{current_time} - #{arg}: File is very big"
          open_log(@bigfiles_log, message)
        when 'error'
          message = "#{current_time} - #{arg}: Error"
          open_log(@error_log, message)
        when 'proccess'
          message = "#{current_time} - #{arg}: Translate complete"
          open_log(@work_log, message)
        when 'key'
          message = "#{current_time} - #{arg} key used"
          open_log(@keys_log, message)
      end
    end
  end

  private

  def open_log(logname, message)
    File.open("#{logname}", "a") { |log| log.puts message.gsub('../', '')}
  end

end