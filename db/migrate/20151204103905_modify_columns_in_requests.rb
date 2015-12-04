class ModifyColumnsInRequests < ActiveRecord::Migration
  def change
    change_table :requests do |t|
      t.remove_references :sender ,:polymorphic => true
      t.remove_references :receiver ,:polymorphic => true
      t.references :source,:polymorphic => true
      t.references :target,:polymorphic => true
    end

  end
end
