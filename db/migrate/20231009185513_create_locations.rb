class CreateLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :locations do |t|
      t.inet :ip_address, null: false, index: { unique: true }
      t.string :country_code, limit: 2, null: false
      t.string :country, limit: 100, null: false
      t.string :city, limit: 100, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false

      t.timestamps
    end
  end
end
