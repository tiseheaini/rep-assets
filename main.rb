#############

get '/:user/print' do
  "#{params[:user]}main"
end

post '/:user/uploads' do

  params[:info].each do |file_name, file|
    file_path = File.join(File.expand_path('.'), 'assets', file_name)
    FileUtils.makedirs(File.dirname(file_path)) if !File.directory?(File.dirname(file_path))
    file_cont = file[:tempfile].read
    File.open(file_path, "a") {|f| f.puts file_cont } 

  end
  "success"
end
