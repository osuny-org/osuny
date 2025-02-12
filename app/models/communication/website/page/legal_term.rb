class Communication::Website::Page::LegalTerm < Communication::Website::Page

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
      title: 'Direction de publication',
      template_kind: :title
    },
    {
      template_kind: :contact,
      data: {
        name: '[Prénom Nom]',
        address: '[Adresse postale]',
        city: '[Ville]',
        zipcode: '[Code postal]',
        country: 'FRANCE',
        emails: [
          '[Adresse email]'
        ]
      }
    },
    {
      title: 'Hébergement',
      template_kind: :title
    },
    {
      template_kind: :contact,
      data: {
        name: 'Deuxfleurs',
        address: '16 rue de la Convention',
        information: 'RDC - Appt. 1',
        city: 'Lille',
        zipcode: '59800',
        country: 'FRANCE',
        url: 'https://deuxfleurs.fr'
      }
    },
  ]
end
