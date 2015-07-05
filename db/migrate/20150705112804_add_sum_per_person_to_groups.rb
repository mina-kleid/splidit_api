class AddSumPerPersonToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :sum_per_person, :decimal, :scale => 10, :precision => 15
  end
end
