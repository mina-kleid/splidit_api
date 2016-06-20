class AddStatusChangedAtToRequests < ActiveRecord::Migration
  def change
    add_column :requests, :status_changed_at, :datetime, default: nil
  end
end
