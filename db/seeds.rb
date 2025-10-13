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

[   {name: "House", subcategories: %i[ Rent Utilities ]}, 
    {name: "Car", subcategories: %i[ Gas Maintenance Repairs ]},
    {name: "Subscriptions", subcategories: %i[ Amazon Netflix ]} ].each do | category |
        c = Category.new(name: category[:name], description: "Description for #{category[:name]}", user_id: user.id)
        c.save
        category[:subcategories].each do | subcategory |
            Subcategory.new(name: subcategory, description: "Description for #{subcategory}", category_id: c.id).save
        end
end

[   "Checking account from bank X", 
    "Checking account from bank Y", 
    "Credit card A",
    "Credit card B" ].each do |source|
        Source.new(name: source, user_id: user.id).save
end

[   {name: "Statement January 2025", source_id: 1, year: 2025, month: 1},
    {name: "Statement January 2025", source_id: 2, year: 2025, month: 1},
    {name: "Statement January 2025", source_id: 3, year: 2025, month: 1},
    {name: "Statement January 2025", source_id: 4, year: 2025, month: 1},
    {name: "Statement February 2025", source_id: 1, year: 2025, month: 2},
    {name: "Statement February 2025", source_id: 2, year: 2025, month: 2},
    {name: "Statement February 2025", source_id: 3, year: 2025, month: 2},
    {name: "Statement February 2025", source_id: 4, year: 2025, month: 2}].each do | document |
        d = Document.new(document.merge({user_id: user.id})).save
end

dates = [
    "2025-01-01",
    "2025-01-02",
    "2025-01-01",
    "2025-02-02",
]

values = Array.new(300) { (rand * (100 - 1) + 1).round(2) }
documents = Document.all
subcategories = Subcategory.all

150.times do |n|
    e = Expense.new
    e.date = dates.sample
    e.description = "Generic #{n}"
    e.value = values.sample
    e.document = documents.sample
    e.subcategory = subcategories.sample
    e.save
end