require 'nokogiri'
require 'open-uri'
require 'pry'

# Terminal colors
$COLOR_1_BG = "\x1b[0;30;43m"
$COLOR_1_FG = "\x1b[0;33;40m"
$COLOR_2_BG = "\x1b[0;30;42m"
$COLOR_2_FG = "\x1b[0;32;40m"
$COLOR_END = "\x1b[0m"

# Number of stories
$NUM_OF_STORIES = 6

class Story
  def get_stories (source, titles, summaries, timestamps, stories_url, num_of_stories)
    @source = source
    @stories = Array.new
    num_of_stories.times { |i|
      @stories[i] = {
        "source" => source,
        "title" => titles[i],
        "summary" => summaries[i],
        "timestamp" => timestamps[i],
        "story_url" => stories_url[i]
      }
    }
    @stories
  end

  def print_stories
    puts "#{$COLOR_2_BG} LATEST STORIES FROM #{@source.upcase} #{$COLOR_END}\n\n"
    @stories.each { |story|
      puts "#{$COLOR_1_BG} #{story['title']} (#{story['timestamp']}) #{$COLOR_END}"
      puts "#{$COLOR_1_FG} #{story['summary']} #{$COLOR_END}\n"
      puts "#{$COLOR_1_FG} #{story['story_url']} #{$COLOR_END}\n\n"
    }
  end
end

class Scraper < Story
  def initialize(url)
    @url = url
    @doc = get_doc
  end

  def get_doc
    html = URI.open(@url)
    Nokogiri::HTML(html)
  end
end

class ApScraper < Scraper
  @@url = 'https://apnews.com/hub/international-news'
  def initialize
    super(@@url)
    @source = 'Associated Press'
    titles = @doc.css('.FeedCard>.CardHeadline>a>h1').map { |h1| h1.content.strip }
    summaries = @doc.css('.FeedCard>a:nth-of-type(2)>div>p').map { |p| p.content.strip }
    timestamps = @doc.css('.FeedCard>.CardHeadline>div>span.Timestamp').map { |span| span.attribute('title').value.strip[22..49] }
    stories_url = @doc.css('.FeedCard>.CardHeadline>a').map { |a| "https://www.apnews.com#{a.attribute('href').value.strip}" }
    get_stories(@source, titles, summaries, timestamps, stories_url, $NUM_OF_STORIES)
  end
end

class BbcScraper < Scraper
  @@url = 'https://www.bbc.com/news/world'
  def initialize
    super(@@url)
    @source = 'BBC'
    _, *titles = @doc.css('.gs-c-promo-heading>h3').map { |h3| h3.content.strip }
    _, *summaries = @doc.css('p.gs-c-promo-summary').map { |p| p.content.strip }
    _, *timestamps = @doc.css('.gs-c-timestamp>time>span.gs-u-vh').map { |span| span.content.strip }
    _, *stories_url = @doc.css('a.gs-c-promo-heading').map { |a| "https://www.bbc.com#{a.attribute('href').value.strip}" }
    get_stories(@source, titles, summaries, timestamps, stories_url, $NUM_OF_STORIES)
  end
end

class ReutersScraper < Scraper
  @@url = 'https://www.reuters.com/news/world'
  def initialize
    super(@@url)
    @source = 'Reuters'
    titles = @doc.css('.story-content>a>h3.story-title').map { |h3| h3.content.strip }
    summaries = @doc.css('.story-content>p').map { |p| p.content.strip }
    timestamps = @doc.css('.story-content>time>span.timestamp').map { |span| span.content.strip }
    stories_url = @doc.css('.story-content>a').map { |a| "https://www.reuters.com#{a.attribute('href').value.strip}" }
    get_stories(@source, titles, summaries, timestamps, stories_url, $NUM_OF_STORIES)
  end
end
