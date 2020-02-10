class GamesController < ApplicationController

  def new
    @letters = ('a'..'z').to_a.sample(10)
  end

  def score
    @word = params[:word].strip
    @letters = params[:letters].strip.chars
    @score = session[:score] || 0
    if is_valid?(@word, @letters) && exists?(@word)
      @answer = "congrats! #{@word}"
      @score += @word.chars.count
    elsif is_valid?(@word, @letters)
      @answer = "#{@word} does not exists"
    else
      @answer = "#{@word} is not in the grid"
    end
    session[:score] = @score
    puts session[:score]
  end

  private

  def is_valid?(word, letters)
    result = true
    word.chars.uniq.each do |letter|
      unless letters.include?(letter)
        result = false
      end
    end
    result
  end

  def exists?(word)
    uri = URI("https://wagon-dictionary.herokuapp.com/#{word}")
    response = JSON.parse(Net::HTTP.get(uri))
    response["found"] == true
  end
end
