module ApiHelper
  def json
    @json ||= JSON.parse(response.body)
  end

  def authorized_request(user, method, path, options = {})
    params = authorized_request_params(user.id).merge(options[:params] || {})
    do_request(method, path, options.merge(params: params))
  end

  def do_request(method, path, options = {})
    headers = request_headers.merge(options[:headers] || {})
    send(method, path, options.merge(headers: headers))
  end

  def authorized_request_params(user_id)
    access_token = FactoryBot.create(:access_token, resource_owner_id: user_id)

    {
      access_token: access_token.token
    }
  end

  def request_headers
    {
      'ACCEPT' => 'application/json'
    }
  end
end