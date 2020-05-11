require "test_helper"

class ApiClientTest < Minitest::Test
  attr_reader :client

  def setup
    @client = EasyMeli::ApiClient.new('test_token')
  end

  def test_get
    stub_verb_request(:get, 'test', query: { param1: 1, param2: 2 })
    response = client.get('test', query: { param1: 1, param2: 2 })
  end

  def test_put
    stub_verb_request(:put, 'test', query: { param1: 1, param2: 2 }, body: 'param3=3')
    response = client.put('test', query: { param1: 1, param2: 2}, body: { param3: 3})
  end

  def test_post
    stub_verb_request(:post, 'test', query: { param1: 1, param2: 2 }, body: 'param3=3')
    response = client.post('test', query: { param1: 1, param2: 2 }, body: { param3: 3})
  end

  def test_delete
    stub_verb_request(:delete, 'test', query: { param1: 1, param2: 2 })
    response = client.delete('test', query: { param1: 1, param2: 2 })
  end

  def test_logger
    logger = mock()
    logger.expects(:log).times(4)
    @client = EasyMeli::ApiClient.new('test_token', logger: logger)
    test_get
    test_post
    test_put
    test_delete
  end

  private

  def stub_verb_request(verb, path, params = {})
    params[:query] = query = params[:query] || {}
    query[:access_token] = 'test_token'
    url = [EasyMeli::ApiClient::API_ROOT_URL, path].join
    stub_request(verb, url).with(params)
  end
end