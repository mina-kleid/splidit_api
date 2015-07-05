class TestController  < ApplicationController

  def test
      puts request.inspect
    @data = { "coincoin" => "o< o<" }

   render :json => @data

  end

end