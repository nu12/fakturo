class BootstrapFakturo < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :subcategories do |t|
      t.string :name
      t.string :description
      t.references :category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :sources do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :statements do |t|
      t.date :date
      t.integer :year
      t.integer :month
      t.boolean :is_upload, default: false
      t.references :source, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    create_table :statement_processings do |t|
      t.text :raw
      t.text :result
      t.string :uuid
      t.references :user, null: false, foreign_key: true
      t.references :source, null: false, foreign_key: true
      t.references :statement, null: false, foreign_key: true

      t.timestamps
    end

    create_table :expenses do |t|
      t.date :date
      t.float :value
      t.boolean :ignore, default: false
      t.string :raw_description
      t.string :description
      t.string :comment
      t.references :statement, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :subcategory, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_column :users, :uuid, :string
    add_column :users, :access_token, :string
    add_column :users, :access_token_expiry_date, :datetime
    add_column :users, :access_token_enabled, :boolean, default: false
  end
end
