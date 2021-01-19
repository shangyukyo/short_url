class ShortUrl < ApplicationRecord

  enum state: {
    pending: 0,
    blocked: -10,
  }

  def s_url
  	url_helpers.s_url_url(self.short_key, host: 'http://localhost:3001')
  end

  def admin_url
  	url_helpers.admin_url(self.short_key, host: 'http://localhost:3001')
  end

	before_create do 		
		chars = [*'a'..'z',*'0'..'9',*'A'..'Z']
		hex = Digest::MD5.hexdigest(target)
		hex_len = hex.length
		sub_hex_len = hex_len / 8

		(0...sub_hex_len).each do |i|
			out_chars = ""
	   		j = i + 1
	   		sub_hex = hex[i * 8...j * 8]
	   		idx = 0x3FFFFFFF & sub_hex.to_i(16)
	   		(0...6).each do |i|
	   			index = 0x0000003D & idx
	   			out_chars += chars[index]
	   			idx = idx >> 5
	   		end	
	   	
	   	if !ShortUrl.find_by(short_key: out_chars)
	   		self.short_key = out_chars
	   		break
	   	end
		end
	end

	def url_helpers
		Rails.application.routes.url_helpers
	end
end
