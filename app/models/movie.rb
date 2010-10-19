class Movie < ActiveRecord::Base
  validates_presence_of :title
  validates_uniqueness_of :title
  #validates_presence_of :description
  #validates_length_of :description, :minimum => 10
  #validates_inclusion_of :rating, :in => %w(G PG PG-13 R NC-17)
  
  def appropriate_for_birthdate?(birthdate)
    #time_at_13 = birthdate+(13*365*24*60*60)
    #time_at_17 = birthdate+(17*365*24*60*60)
    #under_thirteen = time_at_13 > Time.now();
    #under_seventeen = time_at_17 > Time.now();
    
    thirteen_years_ago = Time.now().years_ago(13);
    seventeen_years_ago = Time.now().years_ago(17);
    under_thirteen = birthdate > thirteen_years_ago;
    under_seventeen = birthdate > seventeen_years_ago;
    
    if(self.rating == "PG-13") 
      !under_thirteen
    elsif(self.rating == "R" || self.rating=="NC-17") 
      !under_seventeen
    else 
      return true
    end
  end
  
  def self.find_all_appropriate_for_birthdate(birthdate)
    movies = Movie.find(:all)
    movies.select{|movie| (movie.appropriate_for_birthdate?(birthdate))}
  end
  
end
