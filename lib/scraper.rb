require 'nokogiri'
require 'open-uri'
require 'pry'

# Terminal colors
WORLD_NEWS_COLOR = "\x1b[0;30;43m"
WORLD_NEWS_COLOR_ = "\x1b[0;33;40m"
TECH_NEWS_COLOR = "\x1b[0;30;42m"
TECH_NEWS_COLOR_ = "\x1b[0;32;40m"
DEV_NEWS_COLOR = "\x1b[0;30;47m"
DEV_NEWS_COLOR_ = "\x1b[0;37;40m"
CLOSING_COLOR_BLOCK = "\x1b[0m"

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
  def initialize (source = 'News', titles, summaries, timestamps, num_of_stories)
    @stories = Array.new
    num_of_stories.times { |i|
      @stories[i] = {
        "title" => titles[i],
        "summary" => summaries[i],
        "timestamp" => timestamps[i]
      }
    }
    @stories
  end

  def print_stories
    @stories.each { |story|
      puts "#{$DEV_NEWS_COLOR}#{story['title'].content.strip} (#{story['timestamp'].content.strip})#{$CLOSING_COLOR_BLOCK}"
      puts "#{$DEV_NEWS_COLOR_}#{story['summary'].content.strip}#{$CLOSING_COLOR_BLOCK}\n\n"
    }
  end
end

class Scraper < Story
  def initialize(source, url)
    @source = source
    @url = url
    @doc = get_doc(url)
  end

  def get_doc(url)
    html = open(@url) # Get the HTML from the URL
    doc = Nokogiri::HTML(html) # Get nodes from HTML
    doc
  end
end

class ReutersScraper < Scraper
  # Should return the stories from Reuters
  #@source = 'Reuters'
  #@url = $REUTERS_URL
  #@num_of_stories = $NUM_OF_STORIES

  def get_stories
    titles = @doc.css('.story-content h3.story-title')
    summaries = @doc.css('.story-content>p')
    timestamps = @doc.css('.story-content span.timestamp')
    @stories = Story.new(@source, titles, summaries, timestamps, $NUM_OF_STORIES)
  end
end


reuters_scrape = ReutersScraper.new('Reuters', $REUTERS_URL)
reuters_scrape.get_stories.print_stories