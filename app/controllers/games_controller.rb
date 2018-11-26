require 'rest-client'

class GamesController < ApplicationController
  def new
    @letters = []
    @letters << ('A'..'Z').to_a.sample while @letters.length < 9
  end

  def score
    @guess = params[:guess].upcase
    @letters = params[:letters].split(' ')
    @result = if dictionary(@guess) == false
                "Sorry but #{@guess} does not seem to be a valid English word..."
              elsif valid_word(@guess, @letters) == false
                "Sorry but #{@guess} can't be build out of #{@letters}"
              else
                "Congratulations! #{@guess} is a valid Englih word"
              end
  end

  private

  def valid_word(attempt, grid)
    tmp_attempt = attempt.split('')
    freq_grid = Hash.new(0)
    freq_attempt = Hash.new(0)
    grid.each { |char| freq_grid[char.downcase] += 1 }
    tmp_attempt.each { |char| freq_attempt[char.downcase] += 1 }
    result = []
    freq_attempt.each { |char, freq| freq_grid.key?(char) && freq <= freq_grid[char] ? result << true : result << false }
    return !(result.include? false)
  end

  def dictionary(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_return = RestClient.get(url)
    result = JSON.parse(attempt_return)
    return result["found"]
  end
end
