class GamesController < ApplicationController
  def new
    @grid = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    require 'open-uri'
    require 'json'

    @word = params[:word]
    @grid = params[:grid].split(' ')
    @message = score_and_message(@word, @grid)
  end

  def score_and_message(attempt, grid)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        score = attempt.size * 10
        [score, "Congratulations! #{attempt.upcase} is a valid englich word"]
      else
        [0, "Sorry but #{attempt.upcase} is not an english word"]
      end
    else
      [0, "Sorry but #{attempt.upcase} is not in the grid"]
    end
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
