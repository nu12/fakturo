json.extract! expense, :id, :date, :value, :ignore, :document_id, :subcategory_id, :created_at, :updated_at
json.url expense_url(expense, format: :json)
