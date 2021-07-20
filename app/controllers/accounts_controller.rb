class AccountsController < ApplicationController
  respond_to :html

  before_action :authenticate

  # POST /accounts
  def create
    @account = Account.new(account_params)
    if @account.save then
      redirect_to manage_url, notice: 'User was successfully created.'
    else
      redirect_to manage_url, error: 'Could not created user.'
    end
  end

  # DELETE /accounts/1
  def destroy
    @account = Account.find(params[:id])
    @account.destroy
    redirect_to manage_url, notice: 'User was successfully destroyed.'
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    args = params.require(:account).permit(:netid)
  end
end
