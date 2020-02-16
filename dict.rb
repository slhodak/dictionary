PATHS = {
  TEXT_PATH: '/Users/samhodak/var/dictionary/dict.txt',
  LOG_PATH: '/Users/samhodak/log/dictionary.log',
  PROGRAM_PATH: File.expand_path(__FILE__)
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

def help
  "Dictionary\n\n"\
  "To get a definition:\n"\
  "\s\sdict <word>\n"\
  "\s\sWhere <word> is the word you want the definition of. Words are not case-sensitive.\n"\
  "To open the dictionary:\n"\
  "\s\sdict open\n"\
  "When editing the dictionary:\n"\
  "\s\sType a word or phrase (not case-sensitive) that needs a definition, followed by a ':'.\n"\
  "\s\sOn the next line, enter its definition.\n"\
  "\s\sLeave a blank line between definitions, but never within a single definition.\n\n"\
  "~~Example~~\n"\
  "Traunch:\n"\
  "one of a series of payments to be paid out over a specified period,\nsubject to certain performance metrics being achieved. It is commonly used\nin venture capital (VC) circles to refer to the fundraising rounds used to fund startup companies.\n"\
  "\n"\
  "Another definition:\n"\
  "This would be the second definition in the dictionary. And so on...\n"\
  "~~~~\n\n"\
  "To see the debug logs:\n"\
  "\s\sdict logs\n\n"\
  "Happy Studying!"
end

begin
  if ARGV[0] == 'open'
    system('open -a TextEdit /Users/samhodak/var/dictionary/dict.txt')
  elsif ARGV[0] == 'logs'
    system('open -a TextEdit /Users/samhodak/log/dictionary.log')
  elsif ARGV[0] == 'help'
    puts help
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
