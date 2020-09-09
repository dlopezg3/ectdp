class CreateProjectStageLabels < ActiveRecord::Migration[6.0]
  def change
    create_table :project_stage_labels do |t|
      t.string :name
      t.string :tid
      t.references :legal_state, null: false, foreign_key: true

      t.timestamps
    end
  end
end
