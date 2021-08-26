class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :value
      t.belongs_to :user, foreign_key: true
      t.belongs_to :voteable, polymorphic: true

      t.timestamps
    end

    add_index :votes, [:user_id, :voteable_type, :voteable_id], unique: true
  end
end
