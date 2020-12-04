#!/usr/bin/env ruby
require_relative '../lib/scraper'

def clear
  system 'clear' or system 'cls'
end

def print_stories(scrape)
  loop do
    clear
    scrape.print_stories
    puts "#{$COLOR_2_BG} m #{$COLOR_END}#{$COLOR_2_FG} Menu #{$COLOR_END}#{$COLOR_2_BG} q #{$COLOR_END}#{$COLOR_2_FG} Quit #{$COLOR_END}"
    option = gets.chomp.downcase
    print_menu if option == 'm'
    if option == 'q'
      clear
      exit
    end
  end
end

def print_menu
  loop do
    clear
    puts "#{$COLOR_2_BG} LATEST WORLD NEWS #{$COLOR_END} \n\n"
    puts "#{$COLOR_2_BG} a #{$COLOR_END}#{$COLOR_2_FG} World news from Associated Press #{$COLOR_END}\n\n"
    puts "#{$COLOR_2_BG} b #{$COLOR_END}#{$COLOR_2_FG} World news from BBC #{$COLOR_END}\n\n"
    puts "#{$COLOR_2_BG} r #{$COLOR_END}#{$COLOR_2_FG} World news from Reuters #{$COLOR_END}\n\n"
    puts "\n#{$COLOR_2_BG} q #{$COLOR_END}#{$COLOR_2_FG} Quit #{$COLOR_END}\n\n"
    puts "#{$COLOR_2_FG} Type an option: #{$COLOR_END}"
    option = gets.chomp.downcase
    print_stories(ApScraper.new) if option == 'a'
    print_stories(BbcScraper.new) if option == 'b'
    print_stories(ReutersScraper.new) if option == 'r'
    if option == 'q'
      clear
      exit
    end
  end
end

print_menu
