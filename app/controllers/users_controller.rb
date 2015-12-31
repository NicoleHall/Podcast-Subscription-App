class UsersController < ApplicationController
  protect_from_forgery
  before_filter :authenticate_user!

  def info
    @current_user = current_user
    @subscription = current_user.subscription
    if @subscription.active
      @stripe_customer = Stripe::Customer.retrieve(
        @subscription.stripe_user_id
      )
      @stripe_subscription = @stripe_customer.subscriptions.first
    end
  end

  def cancel_subscription
    @stripe_customer = Stripe::Customer.retrieve(
      current_user.subscription.stripe_user_id
    )
    @stripe_subscription = @stripe_customer.subscriptions.first

    @stripe_subscription.delete
    current_user.subscription.active = false
    redirect_to users_info_path
  end

  def charge
    token = params["stripeToken"]
    customer = Stripe::Customer.create(
      source: token,
      plan: 'mysubscriptionlevel1',
      email: current_user.email
    )

    current_user.subscription.stripe_user_id = customer.id
    current_user.subscription.active = true
    current_user.subscription.save!

    redirect_to users_info_path
  end
end
