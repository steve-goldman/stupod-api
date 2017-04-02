class ChannelItemsLoader

  def load(channel)
    feed = Feedjira::Feed.fetch_and_parse channel.url

    newItems = feed.entries.select do |item|
      !Item.exists? guid: item.entry_id
    end

    newItems.reverse.each do |item|
      ItemLoader.new.load channel, item
    end

    newItems.count
  end
  
end
