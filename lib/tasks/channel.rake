require "open-uri"

namespace :channel do
  desc "Loads channels from a file containing feed URLs"
  task :load_from_file, [:file] => [:environment] do |t, args|
    File.readlines(args[:file]).map(&:strip).each do |feedUrl|
      puts "Loading channel from #{feedUrl}..."
      ChannelLoader.new.load feedUrl
    end
  end

  desc "Loads a channel record from a feed URL"
  task :load, [:feedUrl] => [:environment] do |t, args|
    feedUrl = args[:feedUrl]
    puts "Loading channel from #{feedUrl}..."
    ChannelLoader.new.load feedUrl    
  end

  desc "Loads new items"
  task load_new_items: :environment do
    Channel.all.each do |channel|
      count = ChannelItemsLoader.new.load channel
      puts "Load channel [#{channel.id}] (#{count} items) #{channel.title}"
    end
  end

end
