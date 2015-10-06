
class WordTagDB

  def initialize( file = nil )

    tag = ''
    File.open( file ).each_line do |line|

      case line
      when /^>\s+(\w+)/ then tag = $1
      when /^(\w+)\s*$/ 
        word = stem($1)
        word_tags[word] ||= []
        word_tags[word] << tag
      end
    end
  end

  def lookup( word )
    word_tags[ word ]
  end

  def word_tags
    @word_tags ||= {}
  end

  def stem(word)
    @stemmer ||= Lingua::Stemmer.new
    @stemmer.stem word
  end
end
