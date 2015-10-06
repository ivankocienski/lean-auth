
class MoodDayAnalyzerJob
  
  def initialize( for_user, on_date_s )
    @mood_day_user = for_user
    @mood_day_date = Date.parse(on_date_s)
  end

  def run
    emotion_sum = {}

    MoodDay.transaction do
      log_entries = mood_day.log_entries_for_day

      if log_entries.empty?
        mood_day.destroy
        
      else
        log_entries.each do |lefd|
          lefd.log_entry_emotions.each do |lee|
            emotion_sum[ lee.emotion_id ] ||= 0
            emotion_sum[ lee.emotion_id ] += lee.percentage
          end
        end

        mood_day.mood_day_emotions.destroy_all

        total_entries = log_entries.count.to_f

        emotion_sum.each do |em_id, em_pc|
          mood_day.mood_day_emotions.create emotion_id: em_id, percentage: em_pc / total_entries
        end
      end
    end

  end

  def mood_day
    @mood_day ||= MoodDay::fetch_for_date( @mood_day_user, @mood_day_date )
  end
end

module MoodDayAnalyzer

  @queue = :mood_day_analyzer

  extend self

  def perform( user_id, date_s )
    MoodDayAnalyzerJob.new( user_id, date_s ).run
  end

end
