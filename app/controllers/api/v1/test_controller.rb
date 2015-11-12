class Api::V1::TestController  < ApplicationController

  #this is a test controller to check the availability of the server
  before_filter :check_api_key! , :only => :test_api


  def test
    @data = { "coincoin" => "o< o<" }
    render :json => @data
  end

  def test_api
    @data = { "coincoin" => "o< o<" }
    render :json => @data
  end

end