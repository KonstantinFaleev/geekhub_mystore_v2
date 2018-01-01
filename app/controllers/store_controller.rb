class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order("title").page(params[:page]).per(4)
  end
end
