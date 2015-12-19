require 'twitter'
require 'koala'
require 'fileutils'

def get_images
  Dir.entries('./images').select { |f| !File.directory? f }
end

def get_uploaded_images!
  Dir.entries('./uploaded_images').select { |f| !File.directory? f }
end

def upload
  album_id = '108996499474628'
  fb_oauth_token = 'CAACEdEose0cBAJkt6HOdZA7mOZBtb0MWavuwl5mSVHj66a2Tj97GLzxguFWAea3hxa6BRqEaWTRZAiiLjCU9gewTxlGzytFK63VJKV7fHzRIphZCQClMiZC6akuUFNxqEK34TZBhPbumZClCCGNhZCRAj2v9tZChAdZBJF7txNrH56Od1fwUaZCv2oQpnjiEHlCDrbwwZB1UWm4ZCg37GAcgJELUo'

  # Set message
  message = '#HackFMI6 Having fun with Photo Booth project.'

  # Get images
  all_images = get_images

  client = Twitter::REST::Client.new do |config|
    config.consumer_key = 'fMIOmLqwrZM8lic05HWZCF98W'
    config.consumer_secret = 'UtB85e4R1eCRuHUrelCigXRRrzD1aLsDRqs64TLu4QlKG8vPJV'
    config.access_token = '4526325197-LOhURZmyGNbPLZz1bFnqWex6D3oudDzZOnn00Yv'
    config.access_token_secret = 'iXphmfk5AXnmSDrRM5aKgRz99KPxW2XjAUkRlh7RvRFUk'
  end

  @graph = Koala::Facebook::API.new(fb_oauth_token)

  all_images.each do |img_name|
    twit_image = File.new('./images/' + img_name) 
    fb_image = File.new('./images/' + img_name) 

    begin
      client.update_with_media(message, twit_image)
      @graph.put_picture(fb_image, 'feed', { message: message }, album_id)
    rescue Exception => e
      p e 
    end
  end
end

def move_images
  upload_folder = './uploaded_images'
  unless File.directory?(upload_folder)
    FileUtils.mkdir_p(upload_folder)
  end

  get_images.each do |img|
    FileUtils.move(('./images/' + img), (upload_folder + '/' + img))
  end
end

def move_images_back!
  upload_folder = './images'
  unless File.directory?(upload_folder)
    FileUtils.mkdir_p(upload_folder)
  end

  get_uploaded_images.each do |img|
    FileUtils.move(('./uploaded_images/' + img), (upload_folder + '/' + img))
  end
end
