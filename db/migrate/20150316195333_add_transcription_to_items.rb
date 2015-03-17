class AddTranscriptionToItems < ActiveRecord::Migration
  def change
    add_column :items, :transcription, :text
  end
end
