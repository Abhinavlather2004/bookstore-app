class UsersService

  def self.signup(user_params)
    user = User.new(user_params)
    if user.save
      {success: true, message: "user created successfully", user: user}
    else
      {success: false, error: user.errors.full_messages }
    end
  end

  def self.login(login_params)
    user = User.find_by(email: login_params[:email])

    if user&.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      { success: true, message: "Login successfull", token: token, user: user }
    else
      { success: false, error: "Invalid email or password" }
    end
  end

end
