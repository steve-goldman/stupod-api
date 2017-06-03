Feedjira.configure do |config|
  config.parsers = [
    Feedjira::Parser::ITunesRSS,
    Feedjira::Parser::RSS
  ]
end
