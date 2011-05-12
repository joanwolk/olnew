class PagesController < ApplicationController
  def about
    @title = "About"
  end

  def contact
    @title = "Contact"
  end

end
