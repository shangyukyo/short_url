class CreateShortUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :short_urls do |t|
    	t.string 	:short_key   
    	t.integer :visits, null: false, default: 0    	
  		t.integer :state, null: false, default: 0
  		t.text		:target
      t.timestamps
    end
  end
end
