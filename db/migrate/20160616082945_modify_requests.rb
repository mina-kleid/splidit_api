class ModifyRequests < ActiveRecord::Migration
  def change
    remove_reference :requests, :target, polymorphic: true, index: true
    remove_reference :requests, :source, polymorphic: true, index: true
    add_reference :requests, :target, index: true
    add_reference :requests, :source, index: true
  end
end
