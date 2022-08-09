class CreatePost < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :author
      t.text :content
      t.integer :type, null: false
      t.integer :rating_count

      t.timestamps
    end
  end
end
