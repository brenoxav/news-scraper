require 'nokogiri'
require_relative '../lib/scraper'

describe ApScraper do
  describe '#initialize' do
    it 'creates an instance of the ApScraper class' do
      ap_scraper = ApScraper.new
      expect(ap_scraper).to be_a(ApScraper)
    end
  end
end

describe BbcScraper do
  describe '#initialize' do
    it 'creates an instance of the BbcScraper class' do
      bbc_scraper = BbcScraper.new
      expect(bbc_scraper).to be_a(BbcScraper)
    end
  end
end

describe ReutersScraper do
  describe '#initialize' do
    it 'creates an instance of the ReutersScraper class' do
      reuters_scraper = ReutersScraper.new
      expect(reuters_scraper).to be_a(ReutersScraper)
    end
  end
end
