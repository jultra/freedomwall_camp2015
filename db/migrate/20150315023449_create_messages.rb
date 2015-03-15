class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :message
      t.string :username

      t.timestamps null: false
    end
  end
end
