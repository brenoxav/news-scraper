#!/usr/bin/env ruby
require_relative '../lib/scraper'

def clear
  system "clear" or system "cls"
end

def print_stories(scrape)
  while true do
    clear
    scrape.print_stories
    puts "#{$COLOR_2_BG} m #{$COLOR_END}#{$COLOR_2_FG} Menu #{$COLOR_END}#{$COLOR_2_BG} q #{$COLOR_END}#{$COLOR_2_FG} Quit #{$COLOR_END}"
    option = gets.chomp.downcase
    if option == 'm'
      print_menu
    end
    if option == 'q'
      clear
      exit
    end
  end
end

def print_menu
  while true do
    clear
    puts "#{$COLOR_2_BG} LATEST WORLD NEWS #{$COLOR_END} \n\n"
    puts "#{$COLOR_2_BG} a #{$COLOR_END}#{$COLOR_2_FG} World news from Associated Press #{$COLOR_END}\n\n"
    puts "#{$COLOR_2_BG} b #{$COLOR_END}#{$COLOR_2_FG} World news from BBC #{$COLOR_END}\n\n"
    puts "#{$COLOR_2_BG} r #{$COLOR_END}#{$COLOR_2_FG} World news from Reuters #{$COLOR_END}\n\n"
    puts "\n#{$COLOR_2_BG} q #{$COLOR_END}#{$COLOR_2_FG} Quit #{$COLOR_END}\n\n"
    puts "#{$COLOR_2_FG} Type an option: #{$COLOR_END}"
    option = gets.chomp.downcase
    if option == 'a'
      print_stories(ApScraper.new)
    end
    if option == 'b'
      print_stories(BbcScraper.new)
    end
    if option == 'r'
      print_stories(ReutersScraper.new)
    end
    if option == 'q'
      clear
      exit
    end
  end
end

print_menu
