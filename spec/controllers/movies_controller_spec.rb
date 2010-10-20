require 'spec_helper'
require 'tmdb'

describe MoviesController do

  def mock_movie(stubs={})
    @mock_movie ||= mock_model(Movie, stubs)
  end

  describe "GET index" do
    it "assigns all movies as @movies" do
      Movie.stub(:find).with(:all).and_return([mock_movie])
      get :index
      assigns[:movies].should == [mock_movie]
    end
  end	

  describe "GET show" do
    it "assigns the requested movie as @movie" do
      Movie.stub(:find).with("37").and_return(mock_movie)
      get :show, :id => "37"
      assigns[:movie].should equal(mock_movie)
    end
  end

  describe "GET new" do
    it "assigns a new movie as @movie" do
      Movie.stub(:new).and_return(mock_movie)
      get :new
      assigns[:movie].should equal(mock_movie)
    end
  end

  describe "GET edit" do
    it "assigns the requested movie as @movie" do
      Movie.stub(:find).with("37").and_return(mock_movie)
      get :edit, :id => "37"
      assigns[:movie].should equal(mock_movie)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created movie as @movie" do
        Movie.stub(:new).with({'these' => 'params'}).and_return(mock_movie(:save => true))
        post :createOriginal, :movie => {:these => 'params'}
        assigns[:movie].should equal(mock_movie)
      end

      it "redirects to the created movie" do
        Movie.stub(:new).and_return(mock_movie(:save => true))
        post :createOriginal, :movie => {}
        response.should redirect_to(movie_url(mock_movie))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved movie as @movie" do
        Movie.stub(:new).with({'these' => 'params'}).and_return(mock_movie(:save => false))
        post :createOriginal, :movie => {:these => 'params'}
        assigns[:movie].should equal(mock_movie)
      end

      it "re-renders the 'new' template" do
        Movie.stub(:new).and_return(mock_movie(:save => false))
        post :createOriginal, :movie => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested movie" do
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :movie => {:these => 'params'}
      end

      it "assigns the requested movie as @movie" do
        Movie.stub(:find).and_return(mock_movie(:update_attributes => true))
        put :update, :id => "1"
        assigns[:movie].should equal(mock_movie)
      end

      it "redirects to the movie" do
        Movie.stub(:find).and_return(mock_movie(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(movie_url(mock_movie))
      end
    end

    describe "with invalid params" do
      it "updates the requested movie" do
        Movie.should_receive(:find).with("37").and_return(mock_movie)
        mock_movie.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :movie => {:these => 'params'}
      end

      it "assigns the movie as @movie" do
        Movie.stub(:find).and_return(mock_movie(:update_attributes => false))
        put :update, :id => "1"
        assigns[:movie].should equal(mock_movie)
      end

      it "re-renders the 'edit' template" do
        Movie.stub(:find).and_return(mock_movie(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested movie" do
      Movie.should_receive(:find).with("37").and_return(mock_movie)
      mock_movie.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the movies list" do
      Movie.stub(:find).and_return(mock_movie(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(movies_url)
    end
  end

  describe "submitting valid form" do
    it "should add an entry to the database" do
	  attributes = {:title => "Titanic", :rating => "R", :overview => "A tragic story about a boat",
		:released_on => "1987-11-06 00:00:00", :scores => "5.5", :genre => "drama"}
	  
	  movie = Movie.new(attributes)
	  Movie.stub(:new).and_return(movie)
	  
	  Movie.stub(:find).and_return(movie)
	  post :createOriginal, :movie => attributes
	  assigns[:movie].should equal(movie)
	end
  end
  
  
  describe "interfacing with tmdb" do
    before(:each) do
	  attributes1 = {:title => "Titanic", :rating => "R", :overview => "A tragic story about a boat",
		:released_on => "1987-11-06 00:00:00", :scores => "5.5", :genre => "drama"}
	  attributes2 = {:title => "Train", :rating => "PG-13", :overview => "A movie about a train",
		:released_on => "1987-11-06 00:00:00", :scores => "5.5", :genre => "drama"}
	  attributes3 = {:title => "Transformers", :rating => "PG", :overview => "A movie about transforming",
		:released_on => "1987-11-06 00:00:00", :scores => "5.5", :genre => "drama"}
	  attributes4 = {:title => "Tarpit", :rating => "R", :overview => "What is a tarpit?",
		:released_on => "1987-11-06 00:00:00", :scores => "5.5", :genre => "drama"}
	  attributes5 = {:title => "Tankfighters", :rating => "G", :overview => "Children's film about tankfighters",
		:released_on => "1987-11-06 00:00:00", :scores => "5.5", :genre => "drama"}
	  @movie1 = Movie.new(attributes1)
	  movie2 = Movie.new(attributes2)
	  movie3 = Movie.new(attributes3)
	  movie4 = Movie.new(attributes4)
	  movie5 = Movie.new(attributes5)
	  movieList = [@movie1, movie2, movie3, movie4, movie5]
	  
	  Tmdb.stub(:getTitles).and_return(["Titanic", "Train", "Transformers", "Tarpit", "Tankfighters"])
	  Tmdb.stub(:getAttributes).and_return(attributes1)
	  Movie.stub(:new).and_return(@movie1)
	  Movie.stub(:find).and_return(@movie1)
	end
  
  it "should get 5 movies when requesting movies from tmdb" do
  	  post :results, :title => "transformers"
  	  results = assigns[:titles]
  	  results.first.should == ("Titanic")
  	  results.size.should equal(6)
    end
	  
	it "should add a movie from tmdb to the database" do
	  post :create, :id => 2
	  assigns[:movie].should equal(@movie1)
    end
	  
	it "should flash Movie not found and go back to the search page" do
	  Tmdb.stub(:getTitles).and_return([])
	  post :results, :title => "blahblah"
	  response.should redirect_to(new_movie_path)
    end
  
  end	  
end
