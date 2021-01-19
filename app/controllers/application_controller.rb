class ApplicationController < ActionController::Base

	def render_not_found
		render :file => "/public/404.html", :status => 404
	end
end
