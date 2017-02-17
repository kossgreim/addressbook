shared_examples 'unauthorized request' do

  it 'returns status code 403' do
    expect(response).to have_http_status(403)
  end

  it 'contains error message' do
    expect(json['errors']).to include("You're not authorized to perform this action")
  end
end