class MoviesController < ApplicationController
  def index
    @movies = Movie.all.reverse
    @lists = List.all
  end
end
