module ApplicationHelper

  def form_error_class_on( model, attribute )
    return '' if model.nil? || (model.errors[attribute] || []).empty?
    'has-error'
  end

  def form_error_list( model, attribute )
    return '' if model.nil? || (model.errors[attribute] || []).empty?

    out = '<ul class=\'form-error-list\'>'
    model.errors[attribute].each do |err|
      out += "<li>#{err}</li>"
    end
    out += '</ul>'

    out.html_safe
  end

end
