Rails.configuration.generators do |g|
  g.orm :active_record, primary_key_type: :uuid
end
