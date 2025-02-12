class Communication::Website::Page::CommunicationPost < Communication::Website::Page

  def design_options_block_template_kind
    :posts
  end

  def editable_width?
    false
  end

  def full_width_by_default?
    true
  end

  def design_options_block_template_kind
    :posts
  end

  def dependencies
    super +
    [website.config_default_languages] +
    website.post_categories +
    website.posts
  end

  def git_path_relative
    'posts/_index.html'
  end

  def special_page_categories
    website.post_categories
  end
end
