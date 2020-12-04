require 'pry'
require 'nokogiri'
require 'open-uri'
require_relative '../lib/settings'

# Fetch data from a website
class Scraper
  def initialize
    html = URI.open(@url)
    @doc = Nokogiri::HTML(html)
  end

  def print_stories
    puts "#{COLOR_2_BG} LATEST STORIES FROM #{@source.upcase} #{COLOR_END}\n\n"
    @stories.each do |story|
      puts "#{COLOR_1_BG} #{story['title']} (#{story['timestamp']}) #{COLOR_END}"
      puts "#{COLOR_1_FG} #{story['summary']} #{COLOR_END}\n"
      puts "#{COLOR_1_FG} #{story['story_url']} #{COLOR_END}\n\n"
    end
  end

  private

  def arrange_stories(titles, summaries, timestamps, stories_url)
    @stories = []
    NUM_OF_STORIES.times do |i|
      @stories[i] = {
        'title' => titles[i],
        'summary' => summaries[i],
        'timestamp' => timestamps[i],
        'story_url' => stories_url[i]
      }
    end
  end
end

# Fetch and format data from the AP website
class ApScraper < Scraper
  def initialize
    @source = 'Associated Press'
    @url = 'https://apnews.com/hub/international-news'
    super
    titles = @doc.css('.FeedCard>.CardHeadline>a>h1').map { |h1| h1.content.strip }
    summaries = @doc.css('.FeedCard>a:nth-of-type(2)>div>p').map { |p| p.content.strip }
    timestamps = @doc.css('.FeedCard>.CardHeadline>div>span.Timestamp')
    timestamps = timestamps.map { |span| span.attribute('title').value.strip[22..49] }
    stories_url = @doc.css('.FeedCard>.CardHeadline>a')
    stories_url = stories_url.map { |a| "https://www.apnews.com#{a.attribute('href').value.strip}" }
    arrange_stories(titles, summaries, timestamps, stories_url)
  end
end

# Fetch and format data from the BBC website
class BbcScraper < Scraper
  def initialize
    @source = 'BBC'
    @url = 'https://www.bbc.com/news/world'
    super
    _, *titles = @doc.css('.gs-c-promo-heading>h3').map { |h3| h3.content.strip }
    _, *summaries = @doc.css('p.gs-c-promo-summary').map { |p| p.content.strip }
    _, *timestamps = @doc.css('.gs-c-timestamp>time>span.gs-u-vh').map { |span| span.content.strip }
    _, *stories_url = @doc.css('a.gs-c-promo-heading')
    stories_url = stories_url.map { |a| "https://www.bbc.com#{a.attribute('href').value.strip}" }
    arrange_stories(titles, summaries, timestamps, stories_url)
  end
end

# Fetch and format data from the Reuters website
class ReutersScraper < Scraper
  def initialize
    @source = 'Reuters'
    @url = 'https://www.reuters.com/news/world'
    super
    titles = @doc.css('.story-content>a>h3.story-title').map { |h3| h3.content.strip }
    summaries = @doc.css('.story-content>p').map { |p| p.content.strip }
    timestamps = @doc.css('.story-content>time>span.timestamp').map { |span| span.content.strip }
    stories_url = @doc.css('.story-content>a').map { |a| "https://www.reuters.com#{a.attribute('href').value.strip}" }
    arrange_stories(titles, summaries, timestamps, stories_url)
  end
end
