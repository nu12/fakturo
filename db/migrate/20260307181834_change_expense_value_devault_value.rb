class ChangeExpenseValueDevaultValue < ActiveRecord::Migration[8.1]
  def change
    change_column_default :expenses, :value, from: nil, to: 0
    change_column_null :expenses, :value, false, 0
  end
end
