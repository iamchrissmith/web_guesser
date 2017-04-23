require 'sinatra'
require 'sinatra/reloader'
require 'pry'


SECRET_NUMBER = rand(100)

def eval_message(guess)
  diff = guess - SECRET_NUMBER

  is_correct = ->(diff) { diff == 0 }
  is_way_too_high = ->(diff) { diff >= 5 }
  is_too_high = ->(diff) { diff > 0 }
  is_way_too_low = ->(diff) { diff <= -5 }

  case diff
  when is_correct then "You got it right!<br/>The SECRET NUMBER is #{SECRET_NUMBER}."
  when is_way_too_high then "Way Too high!"
  when is_too_high then "Too high!"
  when is_way_too_low then "Way Too low!"
  else "Too Low!"
  end
end

get '/' do
  guess = params[:guess].to_i

  message = eval_message(guess)

  erb :index, :locals => {
    :number => SECRET_NUMBER,
    :message => message,
  }
end
