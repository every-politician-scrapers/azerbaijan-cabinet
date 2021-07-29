#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      name_and_position.last
    end

    field :position do
      name_and_position.first.gsub(' of the Republic of Azerbaijan', '')
    end

    private

    def name_and_position
      # two different separators are used
      noko.parent.text.split(/\s[\–\-]/).map(&:tidy)
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.map { |member| fragment(member => Member).to_h }
    end

    private

    def member_container
      # The PM has a different layout, so this should catch everyone
      noko.css('.articleBody p strong')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
