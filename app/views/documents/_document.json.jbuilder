json.extract! document, :id, :name, :year, :month, :is_upload, :source_id, :created_at, :updated_at
json.url document_url(document, format: :json)
