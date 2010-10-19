require 'spec_helper'

describe "/movies/index.html.erb" do
  include MoviesHelper

  before(:each) do
    assigns[:movies] = [
      stub_model(Movie,
        :title => "value for title",
        :description => "value for description",
        :rating => "value for rating"
      ),
      stub_model(Movie,
        :title => "value for title",
        :description => "value for description",
        :rating => "value for rating"
      )
    ]
  end

  it "renders a list of movies" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
    response.should have_tag("tr>td", "value for rating".to_s, 2)
  end
end
