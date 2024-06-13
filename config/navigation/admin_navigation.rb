SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::Osuny::SimpleNavigationRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  def load_from_parts class_name, primary
    class_name.parts.each do |part|
      class_name = part.first
      identifier = class_name.to_s.to_sym
      label = class_name.model_name.human(count: 2)
      path = send part.last, lang: current_language.iso_code
      icon = Icon.icon_for class_name
      primary.item identifier, label, path, { icon: icon } if can?(:read, class_name)
    end
  end

  if current_university.is_really_a_university
    navigation.items do |primary|
      if feature_education?
        primary.item :education, Education.model_name.human, admin_education_root_path, { kind: :header, image: 'admin/education-thumb.jpg' }
        load_from_parts Education, primary
        primary.item :education, 'Ressources éducatives', nil, { icon: Icon::EDUCATION_RESOURCES }
        primary.item :education, 'Feedbacks', nil, { icon: Icon::EDUCATION_FEEDBACKS }
      end

      if feature_research?
        primary.item :research, Research.model_name.human, admin_research_root_path, { kind: :header, image: 'admin/research-thumb.jpg' }
        load_from_parts Research, primary
        primary.item :research_watch, 'Veille', nil, { icon: Icon::RESEARCH_WATCH }
      end

      if feature_communication?
        primary.item :communication, Communication.model_name.human, admin_communication_root_path, { kind: :header, image: 'admin/communication-thumb.jpg' }
        load_from_parts Communication, primary
        primary.item :communication_newsletters, 'Lettres d\'information', nil, { icon: Icon::COMMUNICATION_NEWSLETTERS }
      end

      if feature_administration?
        primary.item :administration, Administration.model_name.human, admin_administration_root_path, { kind: :header, image: 'admin/administration-thumb.jpg' }
        load_from_parts Administration, primary
        primary.item :administration_admissions, 'Admissions', nil, { icon: Icon::ADMINISTRATION_ADMISSIONS }
        primary.item :administration_internship, 'Stages', nil, { icon: Icon::ADMINISTRATION_INTERNSHIPS }
        primary.item :administration_statistics, 'Statistiques', nil, { icon: Icon::ADMINISTRATION_STATISTICS }
      end

      if can?(:read, University::Person) || can?(:read, University::Organization)
        primary.item :university, University.model_name.human, admin_university_root_path, { kind: :header, image: 'admin/university-thumb.jpg' }
        load_from_parts University, primary
      end

    end
  else
    navigation.items do |primary|
      primary.item :communication, t('admin.dashboard'), admin_root_path, { kind: :header, image: 'admin/osuny-thumb.jpg' }
      load_from_parts Communication, primary
      primary.item :communication_newsletters, 'Lettres d\'information', nil, { icon: Icon::COMMUNICATION_NEWSLETTERS }
      load_from_parts University, primary
    end
  end
end
