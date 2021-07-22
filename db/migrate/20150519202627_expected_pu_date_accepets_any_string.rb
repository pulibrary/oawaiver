# frozen_string_literal: true

class ExpectedPuDateAccepetsAnyString < ActiveRecord::Migration[5.2]
  def up
    change_column :waiver_infos, :expected_pub_date,  :string
  end

  def down
    change_column :waiver_infos, :expected_pub_date,  :datetime
  end
end
