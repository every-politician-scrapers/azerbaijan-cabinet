#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member
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
  class Members
    def member_container
      # The PM has a different layout, so this should catch everyone
      noko.css('.articleBody p strong')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
