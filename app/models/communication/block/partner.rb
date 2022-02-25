class Communication::Block::Partner < Communication::Block::Template
  def git_dependencies
    dependencies = []
    data['elements'].each do |element|
      element['partners'].each do |partner|
        id = partner.dig('logo', 'id')
        next if id.blank?
        blob = university.active_storage_blobs.find id
        next if blob.nil?
        dependencies += [blob]
      end
    end
    dependencies.uniq
  end
end
