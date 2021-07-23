# frozen_string_literal: true

class DeleteExpectedPubDate < ActiveRecord::Migration
  def up
    remove_column :waiver_infos, :expected_pub_date
  end

  def down
    add_column :waiver_infos, :expected_pub_date, :string
  end
end
