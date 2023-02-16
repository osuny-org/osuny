class Communication::Block::Component::File < Communication::Block::Component::Base

  def blob
    return if data.nil? || data['id'].blank?
    @blob ||= template.block
                      .university
                      .active_storage_blobs
                      .find_by id: data['id']
  end

  def default_data
    {
      'id' => ''
    }
  end

  def direct_dependencies
    [blob]
  end

  def git_dependencies
    [blob]
  end
end
