class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :subscription

  #need to make sure that when a user
  #is created, a corresponding subscription is created as well

  after_create :create_subscription

  def create_subscription
    Subscription.create(user_id: id) if subscription.nil?
  end
end
