def flash(type, msg)
  session['flash'] ||= {}
  session['flash'][type] ||= []
  session['flash'][type] << msg

  @flash[type] ||= []
  @flash[type] << msg

  @flash
end
