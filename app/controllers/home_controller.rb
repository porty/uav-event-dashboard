class HomeController < BasicAuthController

  def index
  end

  def logout
    render plain: 'u r logged out', status: 401
  end

end
