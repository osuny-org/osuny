# used in menu items and in admin navigation
class Icon
  DASHBOARD = 'fas fa-chart-line'

  COMMUNICATION_EXTRANET = 'fas fa-project-diagram'
  COMMUNICATION_WEBSITE = 'fas fa-sitemap'
  COMMUNICATION_WEBSITE_HOME = 'fas fa-home'
  COMMUNICATION_WEBSITE_LOCALIZATIONS = 'fas fa-globe'
  COMMUNICATION_WEBSITE_POST = 'fas fa-newspaper'
  COMMUNICATION_WEBSITE_PAGE = 'fas fa-file'
  COMMUNICATION_WEBSITE_PAGES = 'fas fa-sitemap'
  COMMUNICATION_WEBSITE_MENUS = 'fas fa-bars'
  COMMUNICATION_WEBSITE_AGENDA = 'fas fa-calendar'
  COMMUNICATION_WEBSITE_PORTFOLIO = 'fas fa-briefcase'
  COMMUNICATION_WEBSITE_ANALYTICS = 'fas fa-chart-pie'
  COMMUNICATION_WEBSITE_PREVIEW_MOBILE = 'fas fa-mobile-alt'
  COMMUNICATION_WEBSITE_PREVIEW_TABLET = 'fas fa-tablet-alt'
  COMMUNICATION_WEBSITE_PREVIEW_DESKTOP = 'fas fa-laptop'
  COMMUNICATION_WEBSITE_MENU_BLANK = 'fas fa-font'
  COMMUNICATION_WEBSITE_MENU_URL = 'fas fa-globe'
  COMMUNICATION_EXTRANET_HOME = COMMUNICATION_WEBSITE_HOME
  COMMUNICATION_EXTRANET_ALUMNI = 'fas fa-user-graduate'
  COMMUNICATION_EXTRANET_CONTACTS = 'fas fa-address-book'
  COMMUNICATION_EXTRANET_POSTS = 'fas fa-newspaper'
  COMMUNICATION_EXTRANET_JOBS = 'fas fa-code-branch'
  COMMUNICATION_EXTRANET_DOCUMENTS = 'fas fa-file'
  COMMUNICATION_EXTRANET_LIBRARY = COMMUNICATION_EXTRANET_DOCUMENTS
  COMMUNICATION_NEWSLETTERS = 'fas fa-message'

  EDUCATION_DIPLOMA = 'fas fa-graduation-cap'
  EDUCATION_PROGRAM = 'fas fa-chalkboard-teacher'
  EDUCATION_SCHOOL = 'fas fa-university'
  EDUCATION_TEACHER = 'fas fa-user-graduate'
  EDUCATION_RESOURCES = 'fas fa-laptop'
  EDUCATION_FEEDBACKS = 'fas fa-comments'

  RESEARCH_JOURNAL = 'fas fa-newspaper'
  RESEARCH_JOURNAL_VOLUME = 'fas fa-book'
  RESEARCH_JOURNAL_PAPER = 'fas fa-file'
  RESEARCH_LABORATORY = 'fas fa-flask'
  RESEARCH_RESEARCHER = 'fas fa-microscope'
  RESEARCH_PUBLICATION = 'fas fa-book'
  RESEARCH_THESE = 'fas fa-scroll'
  RESEARCH_WATCH = 'fas fa-eye'
  UNIVERSITY_PERSON_RESEARCHER = RESEARCH_RESEARCHER
  RESEARCH_THESIS = RESEARCH_THESE
  RESEARCH_HAL = RESEARCH_PUBLICATION

  ADMINISTRATION_CAMPUS = 'fas fa-map-marker-alt'
  ADMINISTRATION_LOCATION = 'fas fa-map-marker-alt'
  ADMINISTRATION_ADMISSIONS = 'fas fa-door-open'
  ADMINISTRATION_INTERNSHIPS = 'fas fa-hands-helping'
  ADMINISTRATION_STATISTICS = 'fas fa-chart-bar'
  ADMINISTRATION_QUALITY = 'fas fa-tasks'
  ADMINISTRATION_QUALIOPI = ADMINISTRATION_QUALITY

  UNIVERSITY_ORGANIZATION = 'fas fa-building'
  UNIVERSITY_PERSON = 'fas fa-users'
  UNIVERSITY_PERSON_ADMINISTRATORS = 'fas fa-users-cog'
  UNIVERSITY_PERSON_ALUMNUS = 'fas fa-user-graduate'
  UNIVERSITY_PERSON_TEACHER = EDUCATION_TEACHER

  OSUNY_USER = 'fas fa-user'
  USER = OSUNY_USER

  ADD = 'fas fa-plus'
  ARROW_RIGHT = 'fas fa-arrow-right'
  A11Y = 'fas fa-universal-access'
  CHECK_OK = 'fas fa-check'
  CHECK_KO = 'fas fa-times'
  FOLDER_CLOSED = 'far fa-folder'
  FOLDER_OPENED = 'far fa-folder-open'
  FOLDER_CLOSED_FULL = 'fas fa-folder'
  FOLDER_OPENED_FULL = 'fas fa-folder-open'
  DRAG = 'fas fa-bars'
  DELETE = 'fas fa-times'
  FILE = 'fas fa-file'
  FILTERS = 'fas fa-search'
  MOVE = 'fas fa-arrows-alt'
  SETTINGS = 'fas fa-gear'
  SORT = 'fas fa-sort'
  WARNING = 'fas fa-exclamation-circle'
  PASTE = 'fas fa-paste'

  def self.icon_for(class_name)
    # University::Person::Teacher -> UNIVERSITY_PERSON_TEACHER
    constant = class_name.to_s.remove('::').underscore.upcase
    const_get constant
  end
end
