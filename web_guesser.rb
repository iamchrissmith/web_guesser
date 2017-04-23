require 'sinatra'
require 'sinatra/reloader'
require 'pry'

class NumberGuesser
  attr_reader :secret_number

  @@guesses_left = 5

  def initialize
    @secret_number = rand(100)
  end

  def guesses_left
    return "Last Guess!" if @@guesses_left == 0
    "You have #{@@guesses_left} guesses left."
  end

  def messages(guess)
    {
      no_guess: "Enter your guess:",
      way_too_high: "#{guess} is way too high!",
      too_high: "#{guess} is too high!",
      just_right: "You got it right!<br/>The SECRET NUMBER is #{secret_number}.<br/>A new number has been generated. Enter your guess:",
      way_too_low: "#{guess} is way too low!",
      too_low: "#{guess} is too low!",
      you_lost: "You ran out of guesses.  A new number has been generated. Enter your guess:"
    }
  end

  def cheat(status)
    if !status.nil?
      "CHEAT MODE ENABLE:  The number is #{secret_number}"
    end
  end

  def reset_game
    @@guesses_left = 5
    @secret_number = rand(100)
  end

  def you_win
    reset_game
    return :just_right
  end

  def eval_message(guess)
    if @@guesses_left == 0
      reset_game
      return :you_lost
    end

    return :no_guess if guess.nil?
    @@guesses_left -= 1
    diff = guess.to_i - secret_number

    is_correct      = ->(diff) { diff == 0 }
    is_way_too_high = ->(diff) { diff >= 5 }
    is_too_high     = ->(diff) { diff > 0 }
    is_way_too_low  = ->(diff) { diff <= -5 }

    case diff
    when is_correct then you_win
    when is_way_too_high then :way_too_high
    when is_too_high then :too_high
    when is_way_too_low then :way_too_low
    else :too_low
    end
  end
end

ng = NumberGuesser.new

get '/' do
  guess = params[:guess]

  result = ng.eval_message(guess)



  erb :index, :locals => {
    :number  => ng.secret_number,
    :message => ng.messages(guess)[result],
    :classname   => result.to_s.gsub("_","-"),
    :guesses_left => ng.guesses_left,
    :cheat_mode => ng.cheat(params[:cheat])
  }
end
