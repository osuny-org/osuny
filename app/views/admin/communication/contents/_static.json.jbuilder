json.contents about.contents do |block_or_heading|
  if block_or_heading.is_a? Communication::Block
    json.partial! 'admin/communication/blocks/static', block: block_or_heading
  else
    # TODO
  end
end