Feature: Use TMDb to create movies
	In order to add a movie to the RottenPotatoes database with information from TMDb
	As a user
	I want to find and choose a movie from the TMDb database
	
	Scenario: View 5 movie suggestions
		Given I am on "the create movie page"
		When I fill in "title" with "Titanic"
		And I press "Search"
		Then I should be on "the movie search results page"
		And I should see "Titanic"
		
	Scenario: View 0 movie suggestions
		Given I am on "the create movie page"
		When I fill in "title" with "98r5h398san0njkdsandns081djsandadn09842niufnjdsfn03nlkjdad"
		And I press "Search"
		Then I should be on "the create movie page"
		And I should see "Movie not found."
		
	Scenario: Choose a movie from results page
		Given I am on "the create movie page"
		When I fill in "title" with "Titanic"
		And I press "Search"
		And I select "Titanic" from "id"
		And I press "Create"
		Then I should see "Movie was successfully created"
		
	Scenario: Choose "none of these" from results page
		Given I am on "the create movie page"
		When I fill in "title" with "Titanic"
		And I press "Search"
		And I select "None of these" from "id"
		And I press "Create"
		Then I should be on "the create movie page"