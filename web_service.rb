require 'sinatra/base'
require 'gphoto2'
require 'thin'
require 'thread'

require_relative 'upload_images.rb'

class PhotoBooth < Sinatra::Base
  set :bind, '0.0.0.0'
  set :protection, false

  before do
    headers 'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => ['OPTIONS', 'GET', 'POST']
  end


  get '/shoot' do
    f = open('timeout.txt')

    if f.read.to_i + 10 > Time.now.to_i
      File.open('timeout.txt', 'w') { |file| file.write('Yes') }

      body 'Upload...'

      Thread.new do
        upload
        move_images
      end
    else
      File.open('live.txt', 'w') { |file| file.write('0') }
      sleep(1)

      camera = GPhoto2::Camera.first
      begin
        image_name = Time.now.to_f.to_s.delete('.') << '.jpg'
        file = camera.capture
        file.save('./images/' << image_name)
        camera.close
        File.open('latest_image.txt', 'w') { |file| file.write(image_name) }
        File.open('live.txt', 'w') { |file| file.write('1') }
        File.open('timeout.txt', 'w') { |file| file.write(Time.now.to_i) }

        body 'Successfully captured image: ' << image_name
      rescue
        camera.close
        File.open('latest_image.txt', 'w') { |file| file.write('') }
        File.open('live.txt', 'w') { |file| file.write('1') }

        halt 'The camera couldn\'t focus...'
      end
    end
  end

  get '/check' do
    latest_image = File.read('latest_image.txt')

    if latest_image.nil? or latest_image.empty?
      halt
    else
      File.open('latest_image.txt', 'w') { |file| file.write('') }

      body latest_image
    end
  end

  get '/upload' do
    f = open('timeout.txt')

    if f.read == 'Yes'
      File.open('timeout.txt', 'w') { |file| file.write('0') }
      sleep(1)

      body 'Uploaded!'
    else
      halt
    end
  end

  run!
end
