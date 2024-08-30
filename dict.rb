class Dictionary
  
  def initialize
    @filename = './google-10000-english-no-swears.txt'
    set_word_length
    @dict = load_filtered_dictionary(@filename)
  end

  def load_filtered_dictionary(filename)
    File.readlines(filename).select { |line| line if line.length <= @max_length and line.length >= @min_length}
  end

  def set_word_length
    @max_length = 12
    @min_length = 5
  end

  def select_random_word
    selected_word = nil
    @dict.each_with_index do |word, index|
      selected_word = word if rand < 1.0 / (index + 1)
    end
    selected_word
  end
end