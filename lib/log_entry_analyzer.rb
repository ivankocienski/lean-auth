
class LogEntryAnalazerJob

  WORD_TAG_DB_FILE_NAME = 'emotion-word-tag-db.txt'

  class Tokenizer

    def initialize( from = '' )
      @from_text = from
    end

    def words
      @words ||= string.
        split( /\W+/ ).
        keep_if { |w| w.length > 0 }.
        map { |w| stem(w) }

    end

    def string
      @string ||= @from_text.downcase
    end

    def stem( word )
      @stemmer ||= Lingua::Stemmer.new

      @stemmer.stem word
    end
  end

  class WordFreq

    def initialize( from = [] )
      @input_words = from
    end

    def counts
      return @counts if @counts

      @counts = {}

      @input_words.each do |w|
        @counts[w] = (@counts[w] || 0) + 1
      end

      @counts
    end
  end

  class Tagger
    
    def initialize( from = nil, db = nil )
      #@word_freq = from
      @tokens = from
      @word_tag_db = db
    end
    
    def taggings
      return @taggings if @taggings

      found_tags = {}
      @tokens.each do |tok|
        tags = @word_tag_db.lookup(tok) || []

        tags.each do |tag|
          found_tags[tag] = (found_tags[tag] || 0) + 1
        end
      end

      @taggings = []

      found_tags.each do |t, c|
        @taggings << { name: t, count: c }
      end

      @taggings.sort! do |a, b| 
        if a[:count] == b[:count]
          a[:name] <=> b[:name]
        else 
          b[:count] <=> a[:count] 
        end
      end

      @taggings
    end
  end

  def initialize( le_id )
    @log_entry_id = le_id
  end

  def run
    return if not log_entry

    tokens = Tokenizer.new( log_entry.body )

    taggings = Tagger.new( tokens.words, word_tag_db )

    LogEntry.transaction do
      log_entry.log_entry_emotions.destroy_all

      taggings.taggings.each do |tagging|

        emo = Emotion.where( name: tagging[:name] ).first
        emo ||= Emotion.create!( name: tagging[:name] )

        lee = log_entry.log_entry_emotions.create!( 
          emotion_id: emo.id, 
          count:      tagging[:count],
          percentage: tagging[:count] / tokens.words.count.to_f
        )
      end

      log_entry.analyzed = true
      log_entry.save!

      Resque.enqueue MoodDayAnalyzer, log_entry.user_id, log_entry.created_at.to_s
    end

  end

  def log_entry
    @log_entry ||= LogEntry.where( id: @log_entry_id ).first
  end

  def word_tag_db
    @word_tag_db ||= WordTagDB.new( File.join( Rails.root, 'db', WORD_TAG_DB_FILE_NAME ))
  end
end

module LogEntryAnalazer

  @queue = :log_entry_analyzer
  
  def self.perform( log_entry_id )
    LogEntryAnalazerJob.new( log_entry_id ).run
  end
end

