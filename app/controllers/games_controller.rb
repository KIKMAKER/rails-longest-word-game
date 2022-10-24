require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(5) { %w[A A E E I I O O U U].sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - %w[A A E E I I O O U U]).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || '').upcase
    @included = included?(@word, @letter)
    @english_word = english_word?(@word)
  end

  def included?(_word, _letters)
    @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
