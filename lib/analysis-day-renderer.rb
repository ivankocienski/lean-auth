
class AnalysisDayRenderer

  # this is slightly less crazy than it being in the helper function

  def initialize( days, today, current, start )
    @today       = today
    @current_day = current
    @mood_days   = days
    @start       = start
  end

  def mood_day
    return @mood_day if @mood_day_found
    @mood_days.each do |md|
      next if md.day_in_time != @today
      @mood_day = md
      break
    end
    @mood_day_found = true
    @mood_day
  end

  def stat_code
    out = ''

    emotions = mood_day.mood_day_emotions.order( :percentage )
    emotion_sum = emotions.inject(0) { |sum, e| sum + e.percentage }

    ypos = ((1.0 - emotion_sum) * 152).to_i

    emotions.each do |e|
      height = (e.percentage * 151).to_i

      klass = 'bar'
      klass += " #{e.emotion.name.downcase}"

      style = ''
      style += "height:#{height}px;"
      style += " top:#{ypos}px;"

      title = ''
      title += e.emotion.name.downcase
      title += " #{(e.percentage * 100).round(1)}%"

      out  += %Q{<div class="#{klass}" style="#{style}" title="#{title}" ></div>}
      ypos += height
    end

    out
  end

  def h3_title
    @today.strftime( '%B %d, %Y')
  end

  def h3_body
    @today.mday
  end

  def mood_day_info
    out  = ''
    out += "<div class='emotion-colors stats'>#{stat_code}</div>"
    out += "<h3 title='#{h3_title}'>#{h3_body}</h3>"
    out
  end

  def empty_day_info
    out  = ''
    out += "<div class='stats'>&nbsp;</div>"
    out += "<h3>&nbsp;</h3>"
    out
  end

  def day_code
    return empty_day_info if mood_day.nil?

    if mood_day == @current_day
      mood_day_info

    else
      args  = "day=#{mood_day.id}"
      args += "&start=#{@start}" #if @start

      "<a href='?#{args}'>#{mood_day_info}</a>"
    end
  end

  def li_class
    return '' if mood_day.nil?

    out  = 'day'
    out += ' current' if @current_day && mood_day == @current_day
    out
  end

  def html
    "<li class='#{li_class}'>#{day_code}</li>"
  end

end

