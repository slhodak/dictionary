PATHS = {
  TEXT_PATH: File.expand_path('~/var/dictionary/dict.txt'),
  HELP_PATH: File.expand_path('~/var/dictionary/help.txt'),
  LOG_PATH: File.expand_path('~/log/dictionary.log')
}.freeze

def log(point: '', error: false, finished: false)
  logfile = File.open(PATHS[:LOG_PATH], 'a')
  if error
    logfile.write("[#{Time.now}] - ERROR: #{point.message} | inputs: #{ARGV} | paths: #{PATHS} | trace: #{point.backtrace}\n")
  else
    logfile.write("[#{Time.now}] - DEBUG: point reached: #{point}\n#{finished ? "\n" : nil}")
  end
  logfile.close
end

begin
  if ARGV[0] == 'open'
    system("open -a TextEdit #{PATHS[:TEXT_PATH]}")
  elsif ARGV[0] == 'logs'
    system("open -a TextEdit #{PATHS[:LOG_PATH]}")
  elsif ARGV[0] == 'help'
    system("cat #{PATHS[:HELP_PATH]}")
  elsif ARGV[0] == 'print'
    system("cat #{PATHS[:TEXT_PATH]}")
  else
    log(point: "Looking for #{ARGV[0]}")
    dict = File.open(PATHS[:TEXT_PATH], 'r')
    all_dict = dict.read
    log(point: 'Read dictionary')
    dict.close

    definitions = all_dict.split(/\n\n/)
    dictionary = {}
    definitions.each do |definition|
      log(point: 'Iterating through definitions')
      pair = definition.split(/\:\n/)
      dictionary[pair[0].downcase] = { value: pair[1], key: pair[0] }
    end

    unless dictionary[ARGV[0].downcase]
      puts "No entry '#{ARGV[0]}' in the dictionary. To add it, open the dictionary with the command 'dict open'"
      log(point: "Found no entry for #{ARGV[0]}--did you spell it right?", finished: true)
      return
    end

    puts "#{dictionary[ARGV[0]][:key]}:\n#{dictionary[ARGV[0].downcase][:value]}"
    log(point: "Printed result for '#{ARGV[0]}'. Happy Studying!", finished: true)
  end
rescue StandardError => ex
  log(point: ex, error: true)
end
