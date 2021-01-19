class WelcomeController < ApplicationController
	before_action :find_short_url, only: [:admin, :s_url, :block]

	def index
		gon.short_urls = ShortUrl.all.map{|short_url|
			set_gon(short_url)
		}
	end

	def create
		short_url = ShortUrl.new(short_url_params)
		short_url.save
		render json: set_gon(short_url)
	end


	def s_url
		if @short_url.blocked?
			render_not_found
		else
			@short_url.visits = @short_url.visits.to_i + 1
			@short_url.save

			redirect_to @short_url.target
		end
	end

	def admin		
	end

	def block
		@short_url.blocked!
		redirect_to root_path
	end

	private

	def find_short_url
		@short_url = ShortUrl.find_by(short_key: params[:short_key])
	end

	def short_url_params
		params.permit(:target)
	end

	def set_gon(short_url)
		short_url.as_json.merge(s_url: short_url.s_url, visits: short_url.visits.to_i, state: short_url.state, admin_url: short_url.admin_url)
	end
end