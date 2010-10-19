require 'spec_helper'

describe MoviesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/movies" }.should route_to(:controller => "movies", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/movies/new" }.should route_to(:controller => "movies", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/movies/1" }.should route_to(:controller => "movies", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/movies/1/edit" }.should route_to(:controller => "movies", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/movies" }.should route_to(:controller => "movies", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/movies/1" }.should route_to(:controller => "movies", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/movies/1" }.should route_to(:controller => "movies", :action => "destroy", :id => "1") 
    end
  end
end
