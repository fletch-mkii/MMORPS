require_relative "rockpaperscissors"
require "sinatra"
require "pry"
require "uri"
require "openssl"

def generate_hmac(data, secret)
  OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA1.new, secret, data)
end

def decode_session(str)
  Marshal.load(URI.decode_www_form_component(str).unpack("m").first)
end

use Rack::Session::Cookie, {
  secret: "keep_it_secret_keep_it_safe"
}

get '/index' do
  @string ="BAh7C0kiD3Nlc3Npb25faWQGOgZFVEkiRTcwZjdlZGJiYzIwZDY4NTlkMDYz%0ANTBkNWZjM2ZjZjk5MTI3YzExYzdkYWI1MTE4OWI3NGNiMWUxNzVhMzI4MWIG%0AOwBGSSIOY3B1X3Njb3JlBjsARmkASSIRcGxheWVyX3Njb3JlBjsARmkGSSIR%0Acm91bmRfd2lubmVyBjsARkkiC1BsYXllcgY7AFRJIhJwbGF5ZXJfY2hvaWNl%0ABjsARkkiClBhcGVyBjsAVEkiD2NwdV9jaG9pY2UGOwBGSSIJUm9jawY7AFQ%3D%0A--6a804b22dd54285d6430b35f5cfa79638b8ddc27"
  @decode = decode_session(@string)
  @hmac = generate_hmac(@string,"keep_it_secret_keep_it_safe")
  if session[:cpu_score].nil?
    session[:cpu_score] = 0
  end
  if session[:player_score].nil?
    session[:player_score] = 0
  end
  @player_score = session[:player_score]
  @cpu_score = session[:cpu_score]

  if session[:round_winner] == "tie"
    @message = "It's a tie."
  elsif !session[:round_winner].nil?
    @message = "#{session[:round_winner]} wins the round."
  end
  @player_choice = session[:player_choice]
  @cpu_choice = session[:cpu_choice]
  @winner = session[:winner]

  erb :index
end

post '/index' do
  rps = RockPaperScissors.new(params["choice"])
  session[:cpu_score] += 1 if rps.winner? == "CPU"
  session[:player_score] += 1 if rps.winner? == "Player"
  session[:round_winner] = rps.winner?
  session[:player_choice] = rps.player_choice
  session[:cpu_choice] = rps.cpu_choice
  session[:winner] = "Player" if session[:player_score] >= 2
  session[:winner] = "CPU" if session[:cpu_score] >= 2
  redirect "/index"
end

get '/reset' do
  session.clear
  redirect '/index'
end
