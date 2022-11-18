class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table(:urls, id: :string) do |t|
      t.string :full_url

      t.timestamps
    end

    add_index :urls, :full_url, unique: true
  end
end
