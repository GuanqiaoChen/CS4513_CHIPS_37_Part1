# Second branch for PR approval
class WordGuesserGame
  attr_accessor :word, :guesses, :wrong_guesses

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service

  def initialize(new_word)
    @word = new_word
    @guesses = ''
    @wrong_guesses = ''
  end

  def guess(letter)
    raise ArgumentError if letter.nil? || letter == ''

    ch = letter.downcase
    raise ArgumentError unless ch =~ /^[a-z]$/

    # already guessed (either correct or incorrect)
    return false if @guesses.include?(ch) || @wrong_guesses.include?(ch)

    if @word.downcase.include?(ch)
      @guesses << ch
    else
      @wrong_guesses << ch
    end
    true
  end

  # Show the word with guessed letters revealed and others as '-'
  def word_with_guesses
    return '' if @word.nil?

    @word.chars.map { |c|
      @guesses.include?(c.downcase) ? c : '-'
    }.join
  end

  # :win if all letters guessed; :lose after 7 wrong guesses; else :play
  def check_win_or_lose
    unique_letters = @word.downcase.chars.uniq
    if unique_letters.all? { |c| @guesses.include?(c) }
      :win
    elsif @wrong_guesses.length >= 7
      :lose
    else
      :play
    end
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start do |http|
      return http.post(uri, "").body
    end
  end
end
