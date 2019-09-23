# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Exams GET /orders/:order_id/exams/new', type: :request, js: true do
  let(:employee) { create(:employee) }
  let(:patient) { create(:patient) }
  let(:order) { patient.orders.first }
  let(:exam) { order.exams.first }

  # 全てのアクションにおいてログインが必要です
  before { post login_path, params: { username: employee.username, password: employee.password } }

  before { get new_order_exam_path(order.id) }

  it 'can show all InspectionSet' do
    expect(InspectionSet.all).to eq(assigns[:sets])
  end

  it 'can show all InspectionDetail' do
    expect(InspectionDetail.all).to eq(assigns[:details])
  end

  it { should render_template('new') }
end