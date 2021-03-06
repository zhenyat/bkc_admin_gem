module Admin::BkcHelper
  # Sorts array of objects by the Attribute (if passed)
  def sort_objects objects_array, attribute=nil
    if attribute.nil?
      objects_array
    else
      objects_array.sort! { |a,b| eval("a.#{attribute} <=> b.#{attribute}") }
    end
  end

  # Selects a status mark to be displayed
  def status_mark status
    if status == 'active' || status == true
      image_tag('admin/check_mark.png', size: '12x15', alt: 'Актив')
    else
      image_tag('admin/minus_mark.png', size: '12x15', alt: 'Архив')
    end
  end
end
