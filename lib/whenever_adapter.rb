require 'active_support/core_ext/numeric/time'
class WheneverAdapter
  def parse(datetime,stringMethod)
    stime = datetime.strftime("%H:%M%P")
    @string_task = "every 1.day, :at => #{stime} do
      runner \"#{stringMethod}\"
    end"
  end

  def write
    #todo escrever em schedule
  end
end