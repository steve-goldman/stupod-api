module Response
  def json_response(object, options = {})
    render render_options(object, options)
  end

  private

  def render_options(object, options)
    options[:status] = :ok unless options.key?(:status)
    options[:json] = object
    options
  end
end
