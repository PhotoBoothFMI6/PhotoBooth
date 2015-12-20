require 'gphoto2'

STDOUT.sync = true
get_camera = false

GPhoto2::Camera.first do |camera|
  loop do
    f = open('live.txt')

    if f.read == '1'
      if get_camera
        camera = GPhoto2::Camera.first
        get_camera = false
      else
        File.binwrite('live_view.mjpg', camera.preview.data)
      end
    else
      if not get_camera
        camera.close
        get_camera = true
      end
    end
  end
end
