# encoding: utf-8
#enable :sessions
get '/' do
  "hello sinatra!!!"
end

post '/u/tiny/picture_save_as' do

  file_path = File.join('/home/tiny', 'mhpublic', params[:path])
  FileUtils.makedirs(File.dirname(file_path)) if !File.directory?(File.dirname(file_path))
  File.open(file_path, 'wb'){ |pic| pic.write(params[:picture][:tempfile].read); params[:picture][:tempfile].close }

  [200,{"Content-Type" => "text/plain"}, ["Hello World"]]
end

post '/u/:user/uploads' do

  pass = YAML.load_file(File.join(Dir.pwd, 'rep-asset.yml'))

  if params[:password] == pass['rep-asset']['password']
    FileUtils.rm_rf( File.join('/var', 'public', params[:user]) )
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
