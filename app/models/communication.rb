module Communication
  extend ActiveModel::Naming
  extend ActiveModel::Translation

  def self.table_name_prefix
    'communication_'
  end
end
