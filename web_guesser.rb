require 'sinatra'
require 'sinatra/reloader'
require 'pry'


set :secret_number, rand(100)

def eval_message(guess)
  return :no_guess if guess.nil?
  diff = guess.to_i - settings.secret_number

  is_correct      = ->(diff) { diff == 0 }
  is_way_too_high = ->(diff) { diff >= 5 }
  is_too_high     = ->(diff) { diff > 0 }
  is_way_too_low  = ->(diff) { diff <= -5 }

  case diff
  when is_correct then :just_right
  when is_way_too_high then :way_too_high
  when is_too_high then :too_high
  when is_way_too_low then :way_too_low
  else :too_low
  end
end

get '/' do
  guess = params[:guess]

  messages = {
    no_guess: "Enter your guess:",
    way_too_high: "#{guess} is way too high!",
    too_high: "#{guess} is too high!",
    just_right: "You got it right!<br/>The SECRET NUMBER is #{settings.secret_number}.",
    way_too_low: "#{guess} is way too low!",
    too_low: "#{guess} is too low!"
  }

  result = eval_message(guess)

  erb :index, :locals => {
    :number  => settings.secret_number,
    :message => messages[result],
    :classname   => result.to_s.gsub("_","-")
  }
end
