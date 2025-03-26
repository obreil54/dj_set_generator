class CreateTracks < ActiveRecord::Migration[7.1]
  def change
    create_table :tracks do |t|
      t.string :name, null: false
      t.string :artist, null: false
      t.string :genre, null: false
      t.string :spotify_link, null: false
      t.integer :release_year, null: false
      t.float :bpm, null: false
      t.string :key, null: false
      t.string :open_key, null: false
      t.float :danceability, null: false

      t.timestamps
    end
  end
end
