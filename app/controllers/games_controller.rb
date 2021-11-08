require "open-uri"
require "json"

class GamesController < ApplicationController # rubocop:disable all
  def new
    def generate_grid(grid_size) # rubocop:disable all
      alpha = Array("A".."Z")
      Array.new(grid_size) { alpha.sample }
    end
    @grid = generate_grid(9)

  end

  def self.score # rubocop:disable all
    def valid_word(word) # rubocop:disable all
      attempt_array = word.upcase.chars
      attempt_array.each do |letter|
        if @grid.include?(letter)
          @grid.delete_at(@grid.find_index(letter))
        else
          return false
        end
      end
      return true
    end

    def self.run_game(saisie) # rubocop:disable all
      attempt_m = saisie.upcase.chars
      if valid_word(saisie) == true
        url = "https://wagon-dictionary.herokuapp.com/#{saisie}"
        s_u = URI.open(url).read
        api_r = JSON.parse(s_u)
        if api_r["found"] == true
          score = attempt_m.count * 10
          message = "well done"
        else
          message = "not an english word"
          score = 0
        end
      else
        message = "not in the grid"; score = 0
      end
      @result = { message: message, attempt: saisie, grid: attempt_m, score: score }
    end
  end
end
