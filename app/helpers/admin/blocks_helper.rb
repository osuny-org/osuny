module Admin::BlocksHelper

  def block_component_edit(property, **options)
    component = block_component property
    partial = "admin/communication/blocks/components/#{component.kind}/edit"
    render partial, property: property, **options
  end

  def block_component_preview(property, **options)
    component = block_component property
    partial = "admin/communication/blocks/components/#{component.kind}/preview"
    render partial, property: property, **options
  end

  def block_component_static(property, **options)
    component = block_component property
    partial = "admin/communication/blocks/components/#{component.kind}/static"
    render partial, property: property, **options
  end

  protected

  def block_component(property)
    @block.template.public_send "#{property}_component"
  end
end
