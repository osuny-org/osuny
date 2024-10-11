class Admin::Communication::ContentsController < Admin::Communication::ApplicationController
  before_action :load_about
  layout false

  # /admin/communication/contents/Communication::Website::Page/a788f3ab-a3a8-4d26-9440-6cb12fbf442c/write
  def write
  end

  # /admin/communication/contents/Communication::Website::Page/a788f3ab-a3a8-4d26-9440-6cb12fbf442c/structure
  def structure
  end

  protected

  def load_about
    @about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      mandatory_module: Contentful
    )
    # We check ability on localization's about
    raise_403_unless can?(:update, @about.about)
  end
end