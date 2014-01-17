# encoding: utf-8
#enable :sessions
get '/' do
  "hello sinatra!!!"
end

post '/u/:user/picture_save_as' do
  as_params = params[:info]  ## 原来的 params 信息
  permalink =  params[:permalink]
  episode   =  as_params[:cartoon_pic][:episode].to_s
  cartoon_work_id = as_params[:cartoon_pic][:cartoon_work]
  episode = as_params[:cartoon_pic][:episode]
  cartoon_page = 0

  as_params[:cartoon_pic][:pictures].each do |key,picture|
    next if picture.empty?
    cartoon_page += 1
    file_name = cartoon_page.to_s + File.extname(picture[:filename]).downcase
    file_path = File.join('/var', 'public', 'uploads', 'single', permalink, episode, file_name)
    FileUtils.makedirs(File.dirname(file_path)) if !File.directory?(File.dirname(file_path))
    File.open(file_path, 'wb'){ |pic| pic.write(picture[:tempfile].read); picture[:tempfile].close }
  end

  [200,{"Content-Type" => "text/plain"}, ["Hello World"]]
end

post '/u/:user/uploads' do

  pass = YAML.load_file(File.join(Dir.pwd, 'rep-asset.yml'))

  if params[:password] == pass['rep-asset']['password']
    params[:info].each do |file_name, file|
      file_path = File.join('/var', 'public', params[:user], file_name)
      FileUtils.makedirs(File.dirname(file_path)) if !File.directory?(File.dirname(file_path))
      file_cont = file[:tempfile].read
      File.open(file_path, "a") {|f| f.puts file_cont } 
    end
  else
    halt 499, 'go away!go away!'
  end
  "success"
end
