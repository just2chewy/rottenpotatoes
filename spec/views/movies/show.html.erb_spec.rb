require 'spec_helper'

describe "/movies/show.html.erb" do
  include MoviesHelper
  before(:each) do
    assigns[:movie] = @movie = stub_model(Movie,
      :title => "value for title",
      :description => "value for description",
      :rating => "value for rating"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/value\ for\ rating/)
  end
end
