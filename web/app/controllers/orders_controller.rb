# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :set_patient, only: %i[index new create]
  before_action :set_for_new, only: %i[new create]

  def index
    @orders = @patient.orders.where(canceled: false)
  end

  def new; end

  def create
    p = new_params
    if p[:inspections].nil?
      flash.now[:warning] = '検査項目は必ず指定してください。'
      render :new, status: :bad_request
      return
    end

    @order = @patient.orders.create!(may_result_at: p[:may_result_at])

    # inspections is array of inspection_detail's id(string)
    p[:inspections].each do |id|
      @order.inspections.create!(
        inspection_detail: InspectionDetail.find_by(id: id)
      )
    end

    flash[:success] = "オーダー##{@order.id}を作成しました。"
    CreateLogService.call(
      employee_id: current_employee_id,
      order_id:    @order.id,
      content:     "作成 : 患者#{@order.patient.name}に__を作成しました。"
    )
    redirect_to order_inspections_path(@order)
  end

  def edit
    @order = Order.find_by(id: params[:id])
  end

  def update
    @order = Order.find_by(id: params[:id])
    @order.update!(update_params)

    flash[:success] = '更新しました。'
    CreateLogService.call(
      employee_id: current_employee_id,
      order_id:    @order.id,
      content:     "変更 : __を#{@order.canceled? ? 'キャンセル' : '再予約'}しました。"
    )
    redirect_to patient_orders_path(@order.patient)
  end

  # do not destroy(delete)
  def destroy; end

  private

  # if no inspections selected, must re-render 'new'
  # and set @order and @details
  # because `render` doesn't call as action(same request)
  def set_for_new
    @order = @patient.orders.new
    @sets  = InspectionSet.all
    @details = InspectionDetail.all
  end

  def set_patient
    @patient = Patient.find_by(id: params[:patient_id])
  end

  def new_params
    params.require(:order).permit(:may_result_at, inspections: [])
  end

  def update_params
    params.require(:order).permit(:canceled)
  end
end
