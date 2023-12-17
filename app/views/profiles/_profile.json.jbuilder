json.extract! profile, :id, :index, :name, :surname, :mail, :created_at, :updated_at
json.url profile_url(profile, format: :json)
