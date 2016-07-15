before "/profile/:id" do

  redirect to("/") unless logged_in?
  
end

get '/' do
  erb :index
end

post '/' do
  nombre = params[:name]
  email = params[:email]
  pass = params[:pass]


  @user = User.new(name: nombre, email: email)
  @user.password = pass
    
  if @user.save
    session[:user_id] = @user.id
    redirect to("/profile/#{@user.id}")
  else
    @user.errors.full_messages
    @error = 1
    erb :index
  end

end

get '/login' do 

  erb :login

end

post '/login' do
  email = params[:email]
  pass = params[:pass]

  if User.authenticate(email, pass)
    @user = User.authenticate(email, pass)
    session[:user_id] = @user.id
    redirect to("/profile/#{@user.id}")
  else
    @error = 1
    erb :login
  end

end

get '/profile/:id' do
  current_user  
  id = params[:id]
  @user = current_user  
  erb :profile
end


get '/profile/:id/edit' do
  erb :edit
end

post '/profile/edit' do
  nombre = params[:name]
  email = params[:email]

  @user = User.find_by(email: email)

  if @user.update(name: nombre, email: email)
    redirect to("/profile/#{@user.id}")
  end

end

get '/profile/:id/password' do
  erb :password
end

post '/profile/:id/password' do
  pass = params[:pass1]
  confirmation = params[:pass2]
  @user = User.find(params[:id])

  if @user.password == params[:actual]
    if pass == confirmation 
      @user.password = pass
      @user.save! 
      session.clear
      redirect to("/login")
    else
      @error = 1
      erb :password
    end
  else
    @sinpass = 1
    erb :password
  end
end

get '/profile/:id/delete' do
  if logged_in?
    user = User.find(params[:id])
    user.destroy
    redirect to("/")
  else
    redirect to("/login")
  end
end

get '/outsesion' do
  session.clear
  redirect to("/")
end






