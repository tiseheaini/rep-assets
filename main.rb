#############

get '/' do
  "main"
end

## uri = URI("http://localhost:9292/upload")
## res = Net::HTTP.post_form(uri, 'info' => IO.read('/home/tiny/tiny/zuijin.txt'))'
post '/uploads' do
  #File.open("/home/tiny/tiny/log.txt","a") {|f| f.puts params[:info] }
  File.open("./log.txt","a") {|f| f.write params[:info] }
end
