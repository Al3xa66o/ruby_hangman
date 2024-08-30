require 'yaml'
require_relative 'board.rb'
require_relative 'dict.rb'

class Hangman
  def initialize
    @life = 8
    @guessed_letters = []
    main_menu
  end

  def load_game
    if File.exist?('./saved_games')
      puts "saved file: #{Dir.children('./saved_games')}"
      puts "enter one of the saved games"
      filename = gets.chomp
      load_file(filename)
    else
      puts "no file to load, play a new game"
      main_menu
    end
  end

  def load_file(filename)
    f = YAML.load(File.read("./saved_games/#{filename}.yaml"))
    @word = f[:word]
    @board = f[:board]
    @life = f[:life]
    @guessed_letters = f[:guessed_letters]
  end

  def main_menu
    puts "Press 'n' to start a new game or 'l' to load a saved game"
    input = gets.chomp.downcase
    if input == 'l' || input == 'L'
      
      load_game
    elsif input == 'n' || input == 'N'
      setup_game 
    else
      puts "enter a valid choice"      
    end
  end

  def save_game(filename)
    Dir.mkdir("saved_games") unless Dir.exist?("saved_games")
    f = File.open("saved_games/#{filename}.yaml", 'w') 
    YAML.dump({ :word => @word, :board => @board, :life => @life, @guessed_letters => :guessed_letters}, f)
    f.close
    puts "game saved"
    
  end

  def select_word
    puts 'Selecting a word'
    sleep 0.5
    @word = @word_list.select_random_word
  end

  def guess_valid?
    (@guess =~ /^[A-Z0-9]+$/i && @guess.length == 1)
  end

  def update_lives_left
    @life -= 1
    puts "Lives left. #{@life}"
  end

  def player_input
    puts "Enter a letter to guess, or press '1' to save the game and exit"
    @guess = gets.chomp.downcase
    if @guess == "1"
      puts "enter a filename (no space)"
      filename = gets.chomp
      save_game(filename)
      exit
    end
  end

  def game_over?
    @life <= 0 || @board.complete?
  end

  def check_winner
    if @board.complete?
      puts "Congrats you guessed the word"
      @lose = false
    else
      puts "The word was #{@word}."
      puts "Better luck next time"
      @lose = true
    end
  end

  def update_guessed_letters
    @guessed_letters << @guess
  end

  def setup_board
    @board = Board.new(@word)
  end

  def setup_game
    @word_list= Dictionary.new
    select_word
    setup_board
    play_game
  end

  def play_game
    @board.display
    until game_over?
      player_input
      if guess_valid?
        update_guessed_letters
        @board.update(@guess)
        @board.display
        puts "guessed lettes: #{@guessed_letters}"
        update_lives_left
      else
        puts "enter a valid letter"
      end
    end
    check_winner
  end
end

game = Hangman.new
