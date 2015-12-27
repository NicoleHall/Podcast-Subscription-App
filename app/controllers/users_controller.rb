class UsersController < ApplicationController
  before_filter :authenticate_user!

  def info
    @subscription = current_user.subscription
  end
end
