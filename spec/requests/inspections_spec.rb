require 'rails_helper'

RSpec.describe 'Inspections', type: :request, js: true do
  let(:employee) { create(:employee) }
  let(:patient) { create(:patient) }
  let(:order) { patient.orders.first }
  let(:inspection) { order.inspections.first }

  # all actions are requied logged in
  before { post login_path, params: { username: employee.username, password: employee.password } }

  describe 'GET /orders/:order_id/inspections' do
    before { get "/orders/#{order.id}/inspections" }

    it "can show order's inspections exclude canceled one" do
      expect(order.inspections_only_active).to eq(assigns[:inspections])
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /orders/:order_id/inspections/new' do
    before { get new_order_inspection_path(order.id) }

    it 'can show all InspectionSet' do
      # TODO: define InspectionSet; Current is nil
      expect(InspectionSet.all).to eq(assigns[:sets])
    end

    it 'can show all InspectionDetail' do
      expect(InspectionDetail.all).to eq(assigns[:details])
    end

    it { should render_template('new') }
  end

  describe 'POST /orders/:order_id/inspections' do
    context 'when the request is valid' do
      let(:valid_params) do
        { order: { inspections: (1..10).to_a } }
      end
      before { post order_inspections_path(order.id), params: valid_params }

      it 'creates a order' do
        expect(Order.last).to eq(assigns[:order])
      end

      it { should redirect_to(order_inspections_path(Order.last)) }
    end

    context 'when no inspections selected' do
      let(:invalid_params) do
        { order: { inspections: [] } }
      end
      before { post order_inspections_path(order.id), params: invalid_params }

      it { should render_template('new') }

      it 'returns status code 400(Bad request)' do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe 'GET /inspections/:id/edit' do
    pending 'Use /ajax/inspections/:id/edit to GET modal'
  end

  describe 'PATCH/PUT /inspection/:id/' do
    context 'when request is valid' do
      let(:valid_params) do
        {
          inspection: {
            canceled: true,
            urgent: true,
            status_id: 5,
            sample: 'updated',
            result: 'updated',
            booked_at: Time.zone.now.beginning_of_day + 1.week
          }
        }
      end

      before { put inspection_path(inspection.id), params: valid_params }

      it 'updates inspection' do
        i = Inspection.find(inspection.id)
        expect(i.canceled?).to eq(valid_params[:inspection][:canceled])
        expect(i.urgent?).to   eq(valid_params[:inspection][:urgent])
        expect(i.status_id).to eq(valid_params[:inspection][:status_id])
        expect(i.sample).to    eq(valid_params[:inspection][:sample])
        expect(i.result).to    eq(valid_params[:inspection][:result])
        expect(i.booked_at).to eq(valid_params[:inspection][:booked_at])
      end

      it { should redirect_to(order_inspections_url(inspection.order.id)) }
    end
  end

  describe 'DELETE /inspections/:id' do
    before { delete inspection_path(inspection.id) }

    it 'deletes(discards) inspection' do
      expect(Inspection.with_discarded.find_by(id: inspection.id).discarded?).to be_truthy
    end

    it 'cannot find by any resource because default_scope is set' do
      expect(Inspection.find_by(id: inspection.id)).to be_nil
    end

    it { should redirect_to(order_inspections_url(inspection.order.id)) }
  end
end
