class CreateStockData < ActiveRecord::Migration
  def change
    create_table :stock_day_data do |t|
      t.integer :stock_code
      t.integer :data_time
      t.float :open
      t.float :close
      t.float :high
      t.float :low
      t.integer :volume
      t.float :adj_close

      t.timestamps
    end

    add_index :stock_day_data,[:data_time],:uniq =>false
  end
end
