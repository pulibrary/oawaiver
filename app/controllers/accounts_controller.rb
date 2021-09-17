# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_account!
  respond_to :html

  # POST /accounts
  def create
    @account = Account.new(account_params)

    return redirect_to manage_url, notice: "Account successfully created for #{@account.netid}" if @account.save
    redirect_to manage_url, error: "Could not create a new account for #{@account.netid}"
  end

  # DELETE /accounts/:id
  def destroy
    @account = Account.find(account_id)
    @account.destroy

    redirect_to manage_url, notice: "Account for #{@account.email} was successfully destroyed."
  end

  private

  def account_id
    params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    output = params.require(:account)
    output.permit(:netid)
  end
end
