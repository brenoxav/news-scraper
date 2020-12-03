require 'nokogiri'
require 'open-uri'
require 'pry'

# Terminal colors
$WORLD_NEWS_COLOR = "\x1b[0;30;43m"
$WORLD_NEWS_COLOR_ = "\x1b[0;33;40m"
$TECH_NEWS_COLOR = "\x1b[0;30;42m"
$TECH_NEWS_COLOR_ = "\x1b[0;32;40m"
$DEV_NEWS_COLOR = "\x1b[0;30;47m"
$DEV_NEWS_COLOR_ = "\x1b[0;37;40m"
$CLOSING_COLOR_BLOCK = "\x1b[0m"

# News Sources URL's
$REUTERS_URL = 'https://www.reuters.com/news/world'
$AP_URL = 'https://apnews.com/hub/international-news'
$BBC_URL = 'https://www.bbc.com/news/world'

$THEVERGE_URL = 'https://www.theverge.com/'
$CNET_URL = 'https://www.cnet.com/'
$WIRED_URL = 'https://www.wired.com/'

$FCC_URL = 'https://www.freecodecamp.org/news/'
$DEV_URL = 'https://dev.to/t/webdev'
$TNW_URL = 'https://thenextweb.com/dd/'

# Number of news stories
$NUM_OF_STORIES = 3

class Story
  def initialize (source, titles, summaries, timestamps, stories_url, num_of_stories)
    @source = source
    @stories = Array.new
    num_of_stories.times { |i|
      @stories[i] = {
        "title" => titles[i],
        "summary" => summaries[i],
        "timestamp" => timestamps[i],
        "story_url" => stories_url[i]
      }
    }
    @stories
  end

  def print_stories
    puts "#{$DEV_NEWS_COLOR}\nLATEST STORIES FROM #{@source.upcase}#{$CLOSING_COLOR_BLOCK}\n\n"
    @stories.each { |story|
      puts "#{$DEV_NEWS_COLOR}#{story['title']} (#{story['timestamp']})#{$CLOSING_COLOR_BLOCK}"
      puts "#{$DEV_NEWS_COLOR_}#{story['summary']}#{$CLOSING_COLOR_BLOCK}\n\n"
      puts "#{$DEV_NEWS_COLOR_}#{story['story_url']}#{$CLOSING_COLOR_BLOCK}\n\n"
    }
  end
end

class Scraper < Story
  def initialize(url)
    @url = url
    @doc = get_doc(url)
  end
  def get_doc(url)
    html = URI.open(@url)
    doc = Nokogiri::HTML(html)
    doc
  end
end

class ReutersScraper < Scraper
  def get_stories
    @source = 'Reuters'
    titles = @doc.css('.story-content>a>h3.story-title').map { |h3| h3.content.strip }
    summaries = @doc.css('.story-content>p').map { |p| p.content.strip }
    timestamps = @doc.css('.story-content>time>span.timestamp').map { |span| span.content.strip }
    stories_url = @doc.css('.story-content>a').map { |a| 'https://www.reuters.com'+a.attribute('href').value.strip }
    Story.new(@source, titles, summaries, timestamps, stories_url, $NUM_OF_STORIES)
  end
end

class ApScraper < Scraper
  def get_stories
    @source = 'Associated Press'
    titles = @doc.css('.FeedCard>.CardHeadline>a>h1').map { |h1| h1.content.strip }
    summaries = @doc.css('.FeedCard>a:nth-of-type(2)>div>p').map { |p| p.content.strip }
    timestamps = @doc.css('.FeedCard>.CardHeadline>div>span.Timestamp').map { |span| span.content.strip }
    stories_url = @doc.css('.FeedCard>.CardHeadline>a').map { |a| 'https://www.apnews.com'+a.attribute('href').value.strip }
    Story.new(@source, titles, summaries, timestamps, stories_url, $NUM_OF_STORIES)
  end
end
