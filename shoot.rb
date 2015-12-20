#Shoes.setup do
#  gem 'sinatra'
#  gem 'ffi-gphoto2'
#end
#
#require 'sinatra'
#require 'gphoto2'
#
#set :bind, '0.0.0.0'
#
#get '/shoot' do
#  camera = GPhoto2::Camera.first
#  begin
#    file = camera.capture
#    file.save('./image/' << Time.now.to_f.to_s.delete('.') << '.jpg')
#    file.delete
#  rescue
#    puts "An error occurred."
#  end
#  camera.close
#end
#
#
#Shoes.app :title => "PhotoBooth" do
#  stack :align => 'center' do
#    image 'smiley.png', :width => '866px', :height => '500px', :left => 'center'
#  end
#end

Shoes.setup do
  gem 'sinatra'
  gem 'ffi-gphoto2'
end

require 'sinatra/base'
require 'gphoto2'

Shoes.app :title => "PhotoBooth" do
  stack :align => 'center' do
    image 'smiley.png', :width => '866px', :height => '500px', :left => 'center'
  end
end

class PhotoBooth < Sinatra::Base
  set :bind, '0.0.0.0'

  get '/shoot' do
    camera = GPhoto2::Camera.first
    begin
      file = camera.capture
      file.save('./images/' << Time.now.to_f.to_s.delete('.') << '.jpg')
    rescue
      status 418
      body '418'
    end
    camera.close
  end

  run!
end
