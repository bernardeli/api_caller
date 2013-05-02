class ApiCaller
  def self.request(route = '')
    new(route).request
  end

  attr_reader :endpoint

  def initialize(route = '')
    @endpoint = Endpoint.new(route)
  end

  def request
    case endpoint.attrs.verb.downcase
    when 'get'
      RestClient.get(full_url, headers.merge(params: endpoint.attrs.params))
    when 'post'
      RestClient.post(full_url, endpoint.attrs.params, headers)
    when 'delete'
      RestClient.delete(full_url, headers)
    when 'put'
      RestClient.put(full_url, endpoint.attrs.params, headers)
    end
  end

  private

  def full_url
    File.join(Endpoint.default_url, endpoint.attrs.uri)
  end

  def headers
    Endpoint.headers
  end
end
