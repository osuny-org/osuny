class Ability::Author < Ability

  def initialize(user)
    super
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Post', about_id: managed_posts_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event', about_id: managed_events_ids
    can :manage, Communication::Block, university_id: @user.university_id, about_type: 'Communication::Website::Portfolio::Project', about_id: managed_projects_ids
    can :create, Communication::Block
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Post', about_id: managed_posts_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Agenda::Event', about_id: managed_events_ids
    can :manage, Communication::Block::Heading, university_id: @user.university_id, about_type: 'Communication::Website::Portfolio::Project', about_id: managed_events_ids
    can :create, Communication::Block::Heading
    can :read, Communication::Website, university_id: @user.university_id, id: managed_websites_ids
    can :manage, Communication::Website::Post, university_id: @user.university_id, communication_website_id: managed_websites_ids, author_id: @user.person&.id
    can :manage, Communication::Website::Agenda::Event, university_id: @user.university_id, communication_website_id: managed_websites_ids #, created_by_id: @user.id
    can :manage, Communication::Website::Portfolio::Project, university_id: @user.university_id, communication_website_id: managed_websites_ids #, created_by_id: @user.id
    can :manage, User::Favorite, user_id: @user
  end

  protected

  def managed_posts_ids
    @managed_posts_ids ||= Communication::Website::Post.where(university_id: @user.university_id, author_id: @user.person&.id).pluck(:id)
  end

  def managed_events_ids
    # TODO: rajouter un created_by pour permettre de brider comme les posts
    @managed_events_ids ||= Communication::Website::Agenda::Event.where(university_id: @user.university_id).pluck(:id)
  end
  
  def managed_projects_ids
    # TODO: rajouter un created_by pour permettre de brider comme les posts
    @managed_projects_ids ||= Communication::Website::Portfolio::Project.where(university_id: @user.university_id).pluck(:id)
  end

end