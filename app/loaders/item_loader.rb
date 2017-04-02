class ItemLoader
  def load(channel, item)
    channel.items.create guid: item.entry_id,
                         url: item.enclosure_url,
                         length: item.enclosure_length,
                         file_type: item.enclosure_type,
                         title: item.title,
                         pubDate: item.published,
                         link: item.url,
                         description: item.summary,
                         author: author(item, channel),
                         duration: item.itunes_duration
  end

  private

  def author(item, channel)
    item.author || item.itunes_author || channel.author
  end
end
