class Communication::Website::DeleteObsoleteConnectionsJob < Communication::Website::BaseJob
  def execute
    website.delete_obsolete_connections
  end
end