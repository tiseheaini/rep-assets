# encoding: utf-8
require './model/user'
#enable :sessions
use Rack::Session::Pool, :expire_after => 2592000
use Rack::Flash

set :erb, :layout_engine => :erb, :layout => :users

get '/' do
  @user = User.new
  erb :index
end

get '/index' do
  @user = User.new
  erb :index
end

get '/status' do
  redirect '/' if session[:user_id].blank?
  @user = User.find(session[:user_id])
  erb :status
end

post '/u/sign_in' do
  @user = User.authentication(params[:users][:u_name], params[:users][:password])

  if @user
    session[:user_id] = @user.id
    flash[:sign] = "登录成功"
    redirect '/status'
  else
    flash[:sign] = "登录失败"
    redirect '/index'
  end
end

post '/u/sign_up' do
  @user = User.new(params[:users]) 

  if @user.save
    session[:user_id] = @user.id
    redirect '/index'
  else
    erb :new 
  end
end

post '/u/:user/uploads' do

  params[:info].each do |file_name, file|
    file_path = File.join(File.expand_path('.'), 'assets', file_name)
    FileUtils.makedirs(File.dirname(file_path)) if !File.directory?(File.dirname(file_path))
    file_cont = file[:tempfile].read
    File.open(file_path, "a") {|f| f.puts file_cont } 
  end
  "success"
end
