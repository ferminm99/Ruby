class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
    @links = current_user.links
  end
end
