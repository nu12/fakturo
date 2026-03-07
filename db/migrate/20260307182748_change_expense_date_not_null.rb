class ChangeExpenseDateNotNull < ActiveRecord::Migration[8.1]
  def change
    change_column_null :expenses, :date, false
  end
end
