module DareSubmissionsHelper
  
  def embed(youtube_url)
    youtube_id = youtube_url.split("=").last
    #youtube_id = youtube_url
    content_tag(:iframe, nil, src: "//www.youtube.com/embed/#{youtube_id}")
  end
end