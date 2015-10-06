module ItemMetaHelpers
  def item_meta_array(item_id:)
    [
      "id#{item_id}",
      "name#{item_id}",
      "alternateName#{item_id}",
      "description#{item_id}",
      "'2015/01/01",
      # { year: item_id, month: nil, day: nil, bc: nil, display_text: "dateCreated#{item_id}" }
      "creator#{item_id}",
      "subject#{item_id}",
      "originalLanguage#{item_id}"
    ]
  end

  # An example meta hash using labels
  def item_meta_hash(item_id:)
    {
      "Identifier" => "id#{item_id}",
      "Name" => "name#{item_id}",
      "Alternate Name" => "alternateName#{item_id}",
      "Description" => "description#{item_id}",
      "Date Created" => "'2015/01/01",
      # dateCreated: { year: item_id, month: nil, day: nil, bc: nil, display_text: "dateCreated#{item_id}" },
      "Creator" => "creator#{item_id}",
      "Subject" => "subject#{item_id}",
      "Original Language" => "originalLanguage#{item_id}"
    }
  end

  # An example meta hash using field names
  def item_meta_hash_field_names(item_id:)
    {
      user_defined_id: "id#{item_id}",
      name: "name#{item_id}",
      alternate_name: ["alternateName#{item_id}"],
      creator: ["creator#{item_id}"],
      description: "description#{item_id}",
      subject: ["subject#{item_id}"],
      date_created: { "year" => "2015", "month" => "1", "day" => "1", "bc" => false, "display_text" => nil },
      original_language: ["originalLanguage#{item_id}"],
    }
  end

  # Remapped to all field names
  def item_meta_hash_remapped(item_id:)
    {
      user_defined_id: "id#{item_id}",
      name: "name#{item_id}",
      alternate_name: ["alternateName#{item_id}"],
      creator: ["creator#{item_id}"],
      contributor: nil,
      description: "description#{item_id}",
      subject: ["subject#{item_id}"],
      transcription: nil,
      date_created: { "year" => "2015", "month" => "1", "day" => "1", "bc" => false, "display_text" => nil },
      date_published: nil,
      date_modified: nil,
      original_language: ["originalLanguage#{item_id}"],
      rights: nil,
      call_number: nil,
      provenance: nil,
      publisher: nil,
      manuscript_url: nil
    }
  end

  def item_meta_hash_remapped_to_labels(item_id:)
    {
      "Identifier" => "id#{item_id}",
      "Name" => "name#{item_id}",
      "Alternate Name" => "alternateName#{item_id}",
      "Creator" => "creator#{item_id}",
      "Contributor" => nil,
      "Description" => "description#{item_id}",
      "Subject" => "subject#{item_id}",
      "Transcription" => nil,
      "Date Created" => "'2015/01/01",
      "Date Published" => nil,
      "Date Modified" => nil,
      "Original Language" => "originalLanguage#{item_id}",
      "Rights" => nil,
      "Call Number" => nil,
      "Provenance" => nil,
      "Publisher" => nil,
      "Digitized Manuscript" => nil
    }
  end
end
