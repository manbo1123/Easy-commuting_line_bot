class CreateBusTimetableKaiseiSts < ActiveRecord::Migration[5.0]
  def change
    create_table :bus_timetable_kaisei_sts do |t|
      t.time :datetime, null: false
      t.string :remark
      t.timestamps
    end
  end
end
