class ChannelLoader
  def load feedUrl
    feed = Feedjira::Feed.fetch_and_parse feedUrl
    Channel.create url: feedUrl,
                   title: feed.title,
                   link: feed.url,
                   language: feed.language,
                   description: feed.description,
                   copyright: feed.copyright,
                   image_url: image(feed),
                   author: feed.itunes_author
  end

  private

  def image(feed)
    feed.image.try(:url) || feed.itunes_image
  end
end
