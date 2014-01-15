# encoding: utf-8
#enable :sessions

post '/u/:user/uploads' do

  pass = YAML.load_file(File.join(Dir.pwd, 'rep-asset.yml'))

  if params[:password] == pass[:password]
    params[:info].each do |file_name, file|
      file_path = File.join('/var', 'public', params[:user], file_name)
      FileUtils.makedirs(File.dirname(file_path)) if !File.directory?(File.dirname(file_path))
      file_cont = file[:tempfile].read
      File.open(file_path, "a") {|f| f.puts file_cont } 
    end
  else
    halt 500, 'go away!'
  end
  "success"
end
