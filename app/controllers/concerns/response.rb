module Response
  def json_response(object, serializer = nil)
    render json: object, status: :ok, each_serializer: serializer
  end
end
