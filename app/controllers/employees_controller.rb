# frozen_string_literal: true

class EmployeesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :no_employee

  def index
    @employees = Employee.page(params[:page])
  end

  def show
    @employee = Employee.find(params[:id])
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(create_params)
    if @employee.save
      flash[:success] = '従業員アカウントを作成しました。'
      redirect_to @employee
    else
      flash.now[:warning] = '正しく入力してください。'
      render :new, status: :bad_request
    end
  end

  def edit
    @employee = Employee.find(params[:id])
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.valid_password?(params[:employee][:password]) && @employee.update(update_params)
      flash[:success] = '従業員情報を更新しました。'
      redirect_to @employee
    else
      flash.now[:warning] = '正しく入力してください。'
      render :edit, status: :bad_request
    end
  end

  def destroy
    employee = Employee.find(params[:id])
    employee.discard
    logout
    redirect_to login_url
  end

  private

  def create_params
    params.require(:employee).permit(:fullname, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:employee).permit(:fullname, :email)
  end

  def no_employee
    flash[:warning] = '該当従業員は存在しません。不正なリクエストです。'
    redirect_to employees_path
  end
end
