class Api::V1::TestController  < ApplicationController

  #this is a test controller to check the availability of the server

  def test
      puts request.inspect
    @data = { "coincoin" => "o< o<" }

   render :json => @data

  end

end