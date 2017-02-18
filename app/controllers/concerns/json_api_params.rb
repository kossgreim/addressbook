module JsonApiParams

  private

  def permit_params(permit_params = [])
    ActiveModelSerializers::Deserialization.jsonapi_parse(params, only: permit_params)
  end
end