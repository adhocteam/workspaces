module ApplicationHelper
  
  def display_errors(errors)
    errors && errors.is_a?(ActiveModel::Errors) ? errors.full_messages : errors
  end
end
