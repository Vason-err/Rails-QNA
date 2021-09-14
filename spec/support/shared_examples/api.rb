shared_examples_for 'API Unauthorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: {access_token: '1234'})
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'API Successable' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'API Publicable' do
  it 'returns all public fields' do
    fields.each { |attr| expect(item_response[attr]).to eq item.send(attr).as_json }
  end
end

shared_examples_for 'API Privatable' do
  it 'does not return private fields' do
    fields.each { |attr| expect(item_response).to_not have_key(attr) }
  end
end

shared_examples_for 'API User Containable' do
  it 'contains user object' do
    expect(item_response['user']['id']).to eq item.user_id
  end
end

shared_examples_for 'API Countable' do
  it 'returns all items' do
    expect(items_response.count).to eq(items.count)
  end
end

shared_examples_for 'API Errorable' do
  context 'with errors' do
    let(:question_params) do
      {
        title: 'Title'
      }
    end

    it 'returns 422 status' do
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it 'returns errors' do
      expect(json['errors']).to eq(errors)
    end
  end
end

shared_examples_for 'API Authorize Errorable' do
  context 'with authorize error' do
    it 'returns 401 status' do
      expect(response).to have_http_status(:forbidden)
    end

    it 'returns error' do
      expect(json['errors']).to eq(["You are not authorized to perform this action."])
    end
  end
end
