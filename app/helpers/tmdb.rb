require 'rubygems'
require 'hpricot'
require 'open-uri'


class Tmdb
  def self.getTitles(title)
    titles = Array.[]
    doc = Hpricot(open("http://api.themoviedb.org/2.1/Movie.search/en/xml/881611f82cfe7331c17c5156d380f8ad/" + title))
    doc.search("//movie").each do |item| 
      name = (item/"name").inner_html
      id = (item/"id").inner_html
      titles << [name,id]
    end
	return titles[0, 5]
  end
  
  def self.getAttributes(id)
    attributes = {:title => 'dummy',
       :overview => 'dummy',
       :scores => 'dummy',
       :rating => 'dummy',
       :released_on => 'dummy',
       :genre => 'dummy'}
    
    doc = Hpricot(open("http://api.themoviedb.org/2.1/Movie.getInfo/en/xml/881611f82cfe7331c17c5156d380f8ad/" + id))
    doc.search("//movie").each do |item|   
      name = (item/"name").inner_html
      description = (item/"overview").inner_html
      scores = (item/"rating").inner_html
      rating = (item/"certification").inner_html
      released_on = (item/"released").inner_html
      categories = (item/"categories"/"category")
      genre = ""
      categories.each do |category|
        genre << category.attributes["name"] + ", "
      end
      
      genre = genre[0, genre.length()-2]
      
      attributes = {
       :title => name,
       :overview => description,
       :scores => scores,
       :rating => rating,
       :released_on => released_on,
       :genre => genre}
    end
    return attributes
  end
end
    