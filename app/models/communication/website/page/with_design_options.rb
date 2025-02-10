module Communication::Website::Page::WithDesignOptions
  extend ActiveSupport::Concern

  OPTION_PREFIX = 'option_'

  def design_options?
    design_options_block_template_kind.present?
  end

  def design_options=(value)
    self[:design_options] = JSON.parse(value)
  end

  def design_options
    self[:design_options] || design_options_block.data
  end

  def design_options_hash
    design_options.map { |key, value|
      next unless key.start_with? OPTION_PREFIX
      [key.remove(OPTION_PREFIX), value]
    }.compact
  end

  def design_options_layout
    design_options.dig('layout')
  end

  def design_options_block_template_kind
    :pages
  end

  def design_options_block
    @design_options_block ||= Communication::Block.new(template_kind: design_options_block_template_kind)
  end
end
