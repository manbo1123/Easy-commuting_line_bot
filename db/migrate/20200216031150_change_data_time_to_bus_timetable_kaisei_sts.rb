class ChangeDataTimeToBusTimetableKaiseiSts < ActiveRecord::Migration[5.0]
  def change
    change_column :bus_timetable_kaisei_sts, :time, :time
  end
end
