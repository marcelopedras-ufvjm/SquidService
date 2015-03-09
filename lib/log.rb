require 'date'
class Log
  def self.write
    File.open('log_datetime.txt','a') do |f|
      f.puts(DateTime.now.strftime("%d/%m/%y %H:%M:%S"))
    end
  end
end
