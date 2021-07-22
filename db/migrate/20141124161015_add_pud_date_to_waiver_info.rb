# frozen_string_literal: true

class AddPudDateToWaiverInfo < ActiveRecord::Migration[5.2]
  def up
    add_column :waiver_infos, :expected_pub_date, :datetime
  end

  def down
    remove_column :waiver_infos, :expected_pub_date
  end
end
