class AddNotesToWaiverInfo < ActiveRecord::Migration
  def up
    add_column :waiver_infos, :notes, :string
  end

  def down
    remove_column :waiver_infos, :notes
  end
end
