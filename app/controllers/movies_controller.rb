require 'rubygems'
require 'hpricot'
require 'open-uri'

class MoviesController < ApplicationController
  # GET /movies
  # GET /movies.xml
  def index
    @movies = Movie.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @movies }
    end
  end

  # GET /movies/1
  # GET /movies/1.xml
  def show
    @movie = Movie.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/new
  # GET /movies/new.xml
  def new
    @movie = Movie.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @movie }
    end
  end

  # GET /movies/1/edit
  def edit
    @movie = Movie.find(params[:id])
  end

  # POST /movies
  # POST /movies.xml
  def create
    @name2 = 0
    @id = params[:id]

    attributes = {:title => 'dummy',
       :description => 'dummy',
       :rating => 'dummy',
       :released_on => 'dummy'}
    
    doc = Hpricot(open("http://api.themoviedb.org/2.1/Movie.getInfo/en/xml/881611f82cfe7331c17c5156d380f8ad/" + @id))
    doc.search("//movie").each do |item|   
      name = (item/"name").inner_html
      description = (item/"overview").inner_html
      rating = (item/"certification").inner_html
      released_on = (item/"released").inner_html
      attributes = {
       :title => name,
       :description => description,
       :rating => rating,
       :released_on => released_on
      }
    end
    
    @movie = Movie.new(attributes) 
       
    respond_to do |format|
      if @id!='0' and @movie.save
        format.html { redirect_to(@movie, :notice => 'Movie was successfully created.') }
        format.xml  { render :xml => @movie, :status => :created, :location => @movie }
      else
        format.html { redirect_to(new_movie_path) }
        format.xml  { head :ok }
      end
    end
  end

  # PUT /movies/1
  # PUT /movies/1.xml
  def update
    @movie = Movie.find(params[:id])
    
    respond_to do |format|
      if @movie.update_attributes(params[:movie])
        format.html { redirect_to(@movie, :notice => 'Movie was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @movie.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1
  # DELETE /movies/1.xml
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy

    respond_to do |format|
      format.html { redirect_to(movies_url) }
      format.xml  { head :ok }
    end
  end
  
  def results
    @movie = Movie.new
    @title = params[:title];
    
    #get list of titles from TMDb
    @titles = Array.[]
    
    doc = Hpricot(open("http://api.themoviedb.org/2.1/Movie.search/en/xml/881611f82cfe7331c17c5156d380f8ad/" + @title))
    doc.search("//movie").each do |item| 
      name = (item/"name").inner_html
      id = (item/"id").inner_html
      @titles << [name,id]
    end
    
    @titles = @titles[0,5]
    @titles << ['None of these', 0]
    
    respond_to do |format|
      if (@titles.size() > 1)
        format.html # results.html.erb
        format.xml  { render :xml => @movie }
      else
        format.html { redirect_to(new_movie_path, :notice => 'Movie not found.') }
        format.xml  { head :ok }
      end
    end
  end
end
