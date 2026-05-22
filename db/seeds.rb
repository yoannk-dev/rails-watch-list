# db/seeds.rb
require "json"
require "open-uri"

puts "Nettoyage de la base de données..."
Bookmark.destroy_all
Movie.destroy_all

puts "Importation des films depuis TMDB (Top Rated)..."

api_token = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZjc5ODMxYzdmODY2ODkyZjlhMjFkNTY1MDgwNWE1YSIsIm5iZiI6MTY0MTkwMTg3OS45Njg5OTk5LCJzdWIiOiI2MWRkNmYzNzA3MjkxYzAwMWNkZTEzOGQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.qswzkcVdI9_0dlXunofMZzoI8VYyk0k6qGON3N6lnow"

headers = {
  "Authorization" => "Bearer #{api_token}",
  "accept" => "application/json"
}

movies_count = 0
page = 1

while movies_count < 100 && page <= 5
  url = "https://api.themoviedb.org/3/movie/top_rated?language=fr-FR&page=#{page}"

  begin
    response_serialized = URI.parse(url).open(headers).read
    response = JSON.parse(response_serialized)
    movies = response["results"]

    movies.each do |movie_data|
      break if movies_count >= 100

      poster_url = "https://image.tmdb.org/t/p/w500#{movie_data['poster_path']}"

      movie = Movie.find_or_create_by(title: movie_data["title"]) do |m|
        m.overview = movie_data["overview"]
        m.poster_url = poster_url
        m.rating = movie_data["vote_average"]
      end

      movies_count += 1 if movie.previously_new_record?
    end

    puts "Page #{page} importée..."
    page += 1

  rescue OpenURI::HTTPError => e
    puts "❌ Erreur lors de l'accès à l'API (Vérifie ton token TMDB) : #{e.message}"
    break
  end
end

puts "Terminé ! #{Movie.count} films ont été importés avec succès."
