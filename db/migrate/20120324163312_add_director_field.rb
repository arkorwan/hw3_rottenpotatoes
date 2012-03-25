class AddDirectorField < ActiveRecord::Migration
  def up
    add_column :movies, :director, :string
  end

  def down
    change_table :movies do |t|
      t.remove :director
    end
  end
end
