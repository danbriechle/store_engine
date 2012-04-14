class ApplicationController < ActionController::Base
  protect_from_forgery

  def admin_or_redirect
    if !current_user || !current_user.admin?
      flash[:notice] = "You are not admin. Replace me with 404"
      redirect_to root_path
    end
  end

  helper_method :cart
  def cart
    unless current_user
      anonymous_cart
    else
      user_cart 
    end
  end

  private

  def user_cart
    unless current_user.cart?
      current_user.shopping_cart = ShoppingCart.new
    end  
    current_user.shopping_cart
  end

  def anonymous_cart
    if session[:cart_id].nil?
      ShoppingCart.create.tap{ |cart| session[:cart_id] = cart.id }
    else
      ShoppingCart.find(session[:cart_id])
    end
  end
end
