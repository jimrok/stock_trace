class CreateStocks < ActiveRecord::Migration
  def change
    create_table :stocks do |t|
      t.string :code
      t.string :name
      t.string :short_name
      t.string :market_code

      t.timestamps
    end
  end
end
