class CreateAgents < ActiveRecord::Migration[5.0]
  def change
    create_table :agents do |t|
      t.references :person
      t.text :description

      t.timestamps
    end
  end
end
