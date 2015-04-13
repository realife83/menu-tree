class WelcomesController < ApplicationController
  def index
    render text: 'welcome'
  end
end