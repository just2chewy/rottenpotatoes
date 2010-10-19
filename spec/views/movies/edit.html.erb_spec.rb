require 'spec_helper'

describe "/movies/edit.html.erb" do
  include MoviesHelper

  before(:each) do
    assigns[:movie] = @movie = stub_model(Movie,
      :new_record? => false,
      :title => "value for title",
      :description => "value for description",
      :rating => "value for rating"
    )
  end

  it "renders the edit movie form" do
    render

    response.should have_tag("form[action=#{movie_path(@movie)}][method=post]") do
      with_tag('input#movie_title[name=?]', "movie[title]")
      with_tag('textarea#movie_description[name=?]', "movie[description]")
      with_tag('select#movie_rating[name=?]', "movie[rating]")
    end
  end
end
