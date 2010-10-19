require 'spec_helper'

describe Movie do
 before(:each) do
   @valid_attributes = {
     :title => "Pocahontas",
     :description => "A movie about the new world.",
     :rating => "G",
     :released_on => Time.parse("1/1/1995")
   }
 end

 it "should create a new instance given valid attributes" do
   Movie.create(@valid_attributes).should be_true
 end

 describe "when validating a movie" do
   it "should not allow a movie with no title" do
     @no_title_attributes = {
       :description => "A movie about the new world.",
       :rating => "G",
       :released_on => Time.parse("1/1/1995")
     }
     @movie = Movie.new(@no_title_attributes)
     @movie.should_not be_valid
   end
 
   it "should not allow a movie with no description" do
     @no_description_attributes = {
       :title => "Can't Be Described",
       :rating => "G",
       :released_on => Time.parse("1/1/1995")
     }
     @movie = Movie.new(@no_description_attributes)
     @movie.should_not be_valid
   end
 
   it "should not allow a movie with a title that is not unique" do
     @not_unique_attributes1 = {
       :title => "Inception",
       :description => "Dreams are crazy.",
       :rating => "PG-13",
       :released_on => Time.parse("1/1/1995")
     }
     @not_unique_attributes2 = {
       :title => "Inception",
       :description => "Another version of Inception",
       :rating => "G",
       :released_on => Time.parse("5/4/2010")
     }
     Movie.create(@no_unique_attributes).should be_true
     @movie2 = Movie.new(@no_unique_attributes2)
     @movie2.should_not be_valid
   end
   it "should not allow a movie with a description less than 10 characters long" do
     @short_description_attributes = {
       :title => "Inception",
       :description => "Doh.",
       :rating => "G",
       :released_on => Time.parse("5/4/2010")
     }
     Movie.create(@no_unique_attributes).should be_true
   end
   it "should allow a movie with a valid movie rating" do
     @valid_rating_attributesG = {
       :title => "Inception",
       :description => "Dreams are crazy.",
       :rating => "G",
       :released_on => Time.parse("5/4/2010")
     }
     Movie.create(@valid_rating_attributesG).should be_true
    
     @valid_rating_attributesPG = {
       :title => "InceptionPG",
       :description => "Dreams are crazy.",
       :rating => "PG",
       :released_on => Time.parse("5/4/2010")
     }
     Movie.create(@valid_rating_attributesPG).should be_true
     
     @valid_rating_attributesPG13 = {
       :title => "InceptionPG13",
       :description => "Dreams are crazy.",
       :rating => "PG-13",
       :released_on => Time.parse("5/4/2010")
     }
     Movie.create(@valid_rating_attributesPG13).should be_true
    
     @valid_rating_attributesR = {
       :title => "InceptionR",
       :description => "Dreams are crazy.",
       :rating => "R",
       :released_on => Time.parse("5/4/2010")
     }
     Movie.create(@valid_rating_attributesR).should be_true
     
     @valid_rating_attributesNC17 = {
       :title => "Inception",
       :description => "Dreams are crazy.",
       :rating => "NC-17",
       :released_on => Time.parse("5/4/2010")
     }
     Movie.create(@valid_rating_attributesNC17).should be_true
   end
   it "should not allow a movie with an invalid movie rating" do
     @invalid_rating_attributes = {
       :title => "Inception",
       :description => "Dreams are crazy",
       :rating => "PG-14",
       :released_on => Time.parse("5/4/2010")
     }
     @movie = Movie.new(@short_description_attributes)
     @movie.should_not be_valid
   end
 end
 
 # Add more specs here!
 
 describe "when checking age-appropriateness" do
   it "should be appropriate for a 15-year-old if rated G" do
     @movie = Movie.create!(@valid_attributes)
     @movie.appropriate_for_birthdate?(Time.now()).should be_true
   end
   it "should be appropriate for a 30-year-old if rated G" do
      @movie = Movie.create!(@valid_attributes)
      @movie.appropriate_for_birthdate?(Time.now().years_ago(30)).should be_true
   end
   it "should not be appropriate for a 15-year-old if rated R" do
      @rated_R_attributes = {
       :title => "Inception",
       :description => "Dreams are crazy.",
       :rating => "R",
       :released_on => Time.parse("5/4/2010")
     }
      @movie = Movie.create!(@rated_R_attributes)
      @movie.appropriate_for_birthdate?(Time.now().years_ago(15)).should be_false
   end
 end


 describe "database finder for age-appropriateness" do
   it "should always include G rated movies" do
     @movie = Movie.create!(@valid_attributes)
     Movie.find_all_appropriate_for_birthdate(Time.now).should include(@movie)
   end
   it "should exclude R rated movies if age is less than 17" do
     @movie = Movie.create!(@valid_attributes)
     Movie.find_all_appropriate_for_birthdate(Time.now.years_ago(17)).should include(@movie)
     
     @rated_R_attributes = {
       :title => "Inception",
       :description => "Dreams are crazy.",
       :rating => "R",
       :released_on => Time.parse("5/4/2010")
     }
     @movieR = Movie.create!(@rated_R_attributes)
     Movie.find_all_appropriate_for_birthdate(Time.now.years_ago(17)+1).should_not include(@movieR)
     
     @rated_R_attributes2 = {
       :title => "Inception 2",
       :description => "Dreams are crazy. Again.",
       :rating => "R",
       :released_on => Time.parse("5/4/2010")
     }
     @movieR2 = Movie.create!(@rated_R_attributes2)
     Movie.find_all_appropriate_for_birthdate(Time.now.years_ago(17)+1).should_not include(@movieR2)
   end
 end
end