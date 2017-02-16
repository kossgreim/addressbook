shared_examples 'unauthenticated request' do

  it 'returns status code 401' do
    expect(response).to have_http_status(401)
  end
end