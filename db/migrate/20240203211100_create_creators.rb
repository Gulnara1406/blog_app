class CreateCreators < ActiveRecord::Migration[7.1]
  def change
    create_table :creators do |t|
      t.string :name
      t.timestamps
    end
  end
end
