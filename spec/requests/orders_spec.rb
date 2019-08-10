require 'rails_helper'

RSpec.describe 'Orders', type: :request, js: true do
  # モックとして作成される各患者は
  # 10個の検査からなる1つのオーダーを持ちます
  let(:patient) { create(:patient) }
  let(:order) { patient.orders.first }
  let(:employee) { create(:employee) }

  # 全てのアクションにおいてログインが必要です
  before { post login_path, params: { username: employee.username, password: employee.password } }

  describe 'GET /orders' do
    before { get recent_orders_path }

    it 'can show 20 orders which is created recently' do
      expect(assigns[:orders]).to eq(Order.lists_recently_created)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /patients/:patient_id/orders' do
    before { get "/patients/#{patient.id}/orders" }

    it "can show patient's orders exclude canceled one" do
      expect(assigns[:orders]).to eq(patient.orders_only_active)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /patients/:patient_id/orders/new' do
    before { get "/patients/#{patient.id}/orders/new" }

    it 'can show all InspectionSet' do
      # TODO: InspectionSetはテストにおいて空なので、定義する
      expect(InspectionSet.all).to eq(assigns[:sets])
    end

    it 'can show all InspectionDetail' do
      expect(InspectionDetail.all).to eq(assigns[:details])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST /patients/:patient_id/orders' do
    let(:valid_params) do
      { order: { inspections: (1..10).to_a, may_result_at: Time.zone.now + 10.days } }
    end
    let(:invalid_params) do
      { order: { may_result_at: Time.zone.now + 10.days } }
    end

    context 'when the request is valid' do
      before { post "/patients/#{patient.id}/orders", params: valid_params }

      it 'creates a order' do
        expect(Order.last).to eq(assigns[:order])
      end

      it { should redirect_to(order_inspections_path(Order.last)) }
    end

    context 'when no inspections selected' do
      before { post "/patients/#{patient.id}/orders", params: invalid_params }

      it { should render_template('new') }

      it 'returns status code 400(Bad request)' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /orders/:id/edit' do
    pending 'Use /ajax/orders/:id/edit to GET modal'
  end

  describe 'PATCH/PUT /orders/:id/' do
    context 'when request is valid' do
      let(:valid_params) do
        { order: { canceled: true } }
      end
      before { put order_path(order.id), params: valid_params }

      it 'updates order' do
        expect(Order.find(order.id).canceled?).to be_truthy
      end

      it { should redirect_to(patient_orders_path(order.patient.id)) }
    end
  end

  describe 'DELETE /orders/:id' do
    before { delete order_path(order.id) }

    it 'deletes(discards) order' do
      expect(Order.with_discarded.find_by(id: order.id).discarded?).to be_truthy
    end

    it 'also deletes(discards) releated inspections' do
      order.inspections.each do |inspection|
        expect(inspection.discarded?).to be_truthy
      end
    end

    it 'cannot find by any resource because default_scope is set' do
      expect(Order.find_by(id: order.id)).to be_nil
    end

    it 'returns status code 200 OK' do
      expect(response).to have_http_status(200)
    end

    it 'should show redirect location on body' do
      expect(response.body).to include(patient_orders_url(order.patient.id))
    end
  end
end
