class MoviesController < ApplicationController
  def index
    @movies = Movie.all.reverse
  end
end
