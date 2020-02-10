class GamesController < ApplicationController

  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params[:word].strip
    @letters = params[:letters].strip.chars
    @score = session[:score] || 0
    if valid?(@word, @letters) && exists?(@word)
      @answer = "congrats! #{@word}"
      @score += @word.chars.count
    elsif valid?(@word, @letters)
      @answer = "#{@word} does not exists"
    else
      @answer = "#{@word} is not in the grid"
    end
    session[:score] = @score
  end

  private

  def valid?(word, letters)
    used_letters = []
    word.chars.each do |letter|
      if letters.include?(letter)
        used_letters << letter
      end
    end
    used_letters.count == letters.count
  end

  def exists?(word)
    uri = URI("https://wagon-dictionary.herokuapp.com/#{word}")
    response = JSON.parse(Net::HTTP.get(uri))
    response['found'] == true
  end
end
