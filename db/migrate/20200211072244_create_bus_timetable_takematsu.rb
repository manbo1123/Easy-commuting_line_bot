class CreateBusTimetableTakematsu < ActiveRecord::Migration[5.0]
  def change
    create_table :bus_timetable_takematsu do |t|
      t.time :time, null: false
      t.string :remark
      t.timestamps
    end
  end
end
