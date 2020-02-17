PATHS = {
  TEXT_PATH: File.expand_path('~/var/dictionary/dict.txt'),
  HELP_PATH: File.expand_path('~/var/dictionary/help.txt'),
  LOG_PATH: File.expand_path('~/log/dictionary.log')
}.freeze

def read_dict(argument: '')
  dict_file = File.open(PATHS[:TEXT_PATH], 'r')
  dict = dict_file.read
  log(point: 'Read dictionary')
  dict_file.close
  dict
end

def parse_dict(dict_string: '')
  definitions = dict_string.split(/\n\n/)
  dictionary = {}
  definitions.each do |definition|
    log(point: 'Iterating through definitions')
    pair = definition.split(/\:\n/)
    dictionary[pair[0].downcase] = { value: pair[1], key: pair[0] }
  end
  dictionary
end

def log(point: '', error: false, finished: false)
  logfile = File.open(PATHS[:LOG_PATH], 'a')
  if error
    logfile.write("[#{Time.now}] - ERROR: #{point.message} | inputs: #{ARGV} | paths: #{PATHS} | trace: #{point.backtrace}\n")
  else
    logfile.write("[#{Time.now}] - DEBUG: point reached: #{point}\n#{finished ? "\n" : nil}")
  end
  logfile.close
end

def search(term: '', keys_only: true)
  log(point: "Searching for #{term}")
  dict_string = read_dict
  dictionary = parse_dict(dict_string: dict_string)
  matches = dictionary.select do |key, entry|
    key.match?(/#{term}/i) || (entry[:value].match?(/#{term}/i) && !keys_only)
  end
  matches.each do |key, entry|
    puts "#{key}#{":\n#{entry[:value]}\n\n" unless keys_only}"
  end
  log(point: "Completed search for #{argument}", finished: true)
end

def handleOption(option: '', argument: '')
  log(point: 'Handling option')
  case option
  when '-s'
    search(term: argument)
  when '-sa'
    search(term: argument, keys_only: false)
  else
    puts "Unrecognized option: #{option}"
  end 
end

def handleSpecialCommands(argument: '')
  case argument
  when 'open'
    system("open -a TextEdit #{PATHS[:TEXT_PATH]}")
  when 'logs'
    system("open -a TextEdit #{PATHS[:LOG_PATH]}")
  when 'help'
    system("cat #{PATHS[:HELP_PATH]}")
  when 'print'
    system("cat #{PATHS[:TEXT_PATH]}")
  else
    false
  end
end

begin
  if handleSpecialCommands(argument: ARGV[0])
    return
  end

  if ARGV[0].match?(/^-/)
    if ARGV[1]
      handleOption(option: ARGV[0], argument: ARGV[1])
    else
      puts 'No arguments given.'
    end
  else
    log(point: "Looking for #{ARGV[0]}")
    dict_string = read_dict

    dictionary = parse_dict(dict_string: dict_string)

    unless dictionary[ARGV[0].downcase]
      puts "No entry '#{ARGV[0]}' in the dictionary. To add it, open the dictionary with the command 'dict open'"
      log(point: "Found no entry for #{ARGV[0]}--did you spell it right?", finished: true)
      return
    end

    puts "#{dictionary[ARGV[0].downcase][:key]}:\n#{dictionary[ARGV[0].downcase][:value]}"
    log(point: "Printed result for '#{ARGV[0]}'. Happy Studying!", finished: true)
  end
rescue StandardError => ex
  log(point: ex, error: true)
end
