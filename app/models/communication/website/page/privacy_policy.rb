class Communication::Website::Page::PrivacyPolicy < Communication::Website::Page

  def design_options_block_template_kind
    nil
  end

  def draftable?
    false
  end

  def is_listed_among_children?
    false
  end

  def default_menu_identifier
    'legal'
  end

  TEMPLATE_BLOCKS = [
    {
      title: 'Mesure d\'audience',
      template_kind: :title
    },
    {
      template_kind: :chapter,
      data: {
        text: '<p>La mesure d\'audience est réalisée par <a href="https://plausible.io" target="_blank" rel="noreferrer">Plausible</a>, une solution en source ouverte respectueuse de la vie privée. La solution est hébergée en Allemagne (Hetzner), et opérée par une société en Estonie. La mesure d\'audience n\'utilise pas de cookies.</p>'
      }
    },
    {
      title: 'Cookies',
      template_kind: :title
    },
    {
      template_kind: :chapter,
      data: {
        text: '<p>Le site s\'appuie sur le système de gestion de contenu <a href="https://www.osuny.org" target="_blank" rel="noreferrer">Osuny</a>, qui n\'utilise aucun cookie. Des cookies peuvent toutefois être utilisés par des services tiers. Parmi ces services, certaines plateformes vidéos peuvent imposer des cookies malgré la demande explicite de ne pas le faire. D\'autres services, notamment intégrés avec des iframes, ont leur propre politique de cookies.</p>'
      }
    },
  ]
  
end
