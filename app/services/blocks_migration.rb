require 'communication/block/template/base'
require 'communication/block/template/chapter'

class BlocksMigration

  def self.cleanup
    Communication::Website::Post.find_each do |post|
      cleanup_item post
    end
    Communication::Website::Page.find_each do |page|
      cleanup_item page
    end
  end

  private

  def self.cleanup_item(item)
    return if item.text.blank?
    puts "#{item} (#{item.id}, #{item.university}, #{item.website})"
    return if item.blocks.any?
    puts "  migrating"
    puts item.text.to_html
    return
    block = item.blocks.create university: item.university, template_kind: :chapter
    data = block.data
    data['text'] = item.text.to_html
    block.data = data
    block.save
  end
end
