class CreateDirections < ActiveRecord::Migration
  def change
    create_table :directions do |t|
      t.string :from
      t.string :to
      t.string :route

      t.timestamps
    end
  end
end
