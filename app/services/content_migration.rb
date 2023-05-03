class ContentMigration

  def self.run
    ContentMigration.new.migrate_all
  end

  def migrate_all
    about_types.each do |about_type|
      migrate_objects(about_type)
    end
  end

  def migrate(object)
    puts object
    heading = nil
    heading_position = 0
    object.blocks.each do |block|
      # ignore blocks already inside headings
      next if block.heading.present?
      # Move title from block to heading
      if block.title.present?
        heading = object.headings.create(university: object.university)
        heading.title = block.title
        heading.position = heading_position
        heading.save
        heading_position += 1
        block.title = ''
        block.save
      end
      # Add blocks to current heading
      block.heading = heading
      block.save
    end
  end
  
  protected

  def about_types
    Communication::Block.pluck(:about_type).uniq
  end

  def about_ids(about_type)
    Communication::Block.where(about_type: about_type).pluck(:about_id).uniq
  end

  def migrate_objects(about_type)
    about_ids(about_type).each do |about_id|
      object = about_type.constantize.find(about_id)
      migrate(object)
    end
  end

end