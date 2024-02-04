class DropCreatorsTable < ActiveRecord::Migration[7.1]
  def up
    drop_table :creators
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
