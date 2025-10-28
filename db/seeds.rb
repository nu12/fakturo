# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.new(username: "test", password: "123456")
user.save

[   { name: "House", subcategories: %i[ Rent Utilities ] },
    { name: "Car", subcategories: %i[ Gas Maintenance Repairs ] },
    { name: "Subscriptions", subcategories: %i[ Amazon Netflix ] } ].each do | category |
        c = Category.new(name: category[:name], description: "Description for #{category[:name]}", user_id: user.id)
        c.save
        category[:subcategories].each do | subcategory |
            Subcategory.new(name: subcategory, description: "Description for #{subcategory}", category_id: c.id, user_id: user.id).save
        end
end

[   "Checking account from bank X",
    "Checking account from bank Y",
    "Credit card A",
    "Credit card B" ].each do |source|
        Source.new(name: source, user_id: user.id).save
end

[   { source_id: 1, date: "2025-01-10" },
    { source_id: 2, date: "2025-01-10" },
    { source_id: 3, date: "2025-01-10" },
    { source_id: 4, date: "2025-01-10" },
    { source_id: 1, date: "2025-02-10" },
    { source_id: 2, date: "2025-02-10" },
    { source_id: 3, date: "2025-02-10" },
    { source_id: 4, date: "2025-02-10" } ].each do | statement |
        Statement.new(statement.merge({ user_id: user.id })).save
end

dates = [
    "2025-01-01",
    "2025-01-02",
    "2025-01-01",
    "2025-02-02"
]

values = Array.new(300) { (rand * (100 - 1) + 1).round(2) }
statements = Statement.all
subcategories = Subcategory.all

150.times do |n|
    e = Expense.new
    e.date = dates.sample
    e.description = "Generic #{n}"
    e.value = values.sample
    e.statement = statements.sample
    e.subcategory = subcategories.sample
    e.category = e.subcategory.category
    e.user = user
    e.save
end
