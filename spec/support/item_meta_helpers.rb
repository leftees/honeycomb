module ItemMetaHelpers
  def item_meta_array(item_id:)
    [
      "id#{item_id}",
      "name#{item_id}",
      "alternativeName#{item_id}",
      "description#{item_id}",
      "2015-01-01",
      # { year: item_id, month: nil, day: nil, bc: nil, display_text: "dateCreated#{item_id}" }
      "creator#{item_id}",
      "subject#{item_id}",
      "originalLanguage#{item_id}"
    ]
  end

  def item_meta_hash(item_id:)
    {
      Identifier: "id#{item_id}",
      Name: "name#{item_id}",
      :"Alternative Name" => "alternativeName#{item_id}",
      Description: "description#{item_id}",
      :"Date Created" => "2015-01-01",
      # dateCreated: { year: item_id, month: nil, day: nil, bc: nil, display_text: "dateCreated#{item_id}" },
      Creator: "creator#{item_id}",
      Subject: "subject#{item_id}",
      :"Original Language" => "originalLanguage#{item_id}"
    }
  end
end
