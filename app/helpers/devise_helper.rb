module DeviseHelper

  # intercept devise errors and display them as flash messages
  def devise_error_messages!
    return if resource.errors.empty?
    str = ''
    resource.errors.full_messages.each do |msg|
      str += "#{msg}. "
    end
    flash.now[:devise_error] = str
    return
  end
end
