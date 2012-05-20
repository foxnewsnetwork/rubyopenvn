class PagesController < ApplicationController
  def home
  	@title = "FFOpenVN"
  	@referer= params['referer']
  	@header = { 
  		"HTTP_USER_AGENT" => request.headers["HTTP_USER_AGENT"] ,
  		"REMOTE_ADDR" => request.headers["REMOTE_ADDR"]
  	} # end header
  	@laptop = /mac/i.match( @header['HTTP_USER_AGENT'] ).nil? ? "/images/splash-pc.png" : "/images/splash-mac.png"
  end

  def legal
  end
  
  def error404
    render "404"
  end
end
