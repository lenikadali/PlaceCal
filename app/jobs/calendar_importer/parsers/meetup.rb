# frozen_string_literal: true

# In order for a parser to be recognized, it must be added
# to the PARSERS constant list in app/models/calendar_parser.rb.
# Parent parser classes should not be added.

module CalendarImporter::Parsers
  class Meetup < Base
    NAME = 'Meetup'
    KEY = 'meetup'
    DOMAINS = %w[www.meetup.com]

    def self.whitelist_pattern
      /^https:\/\/www\.meetup\.com\/[^\/]*\/?$/
    end

    def download_calendar
      user_name = (@url =~ /^https:\/\/www\.meetup\.com\/([^\/]*)\/?$/) && $1
      return [] unless user_name.present?

      api_url = "https://api.meetup.com/#{user_name}/events"
      response = HTTParty.get(api_url).body
      JSON.parse response
    end

    def import_events_from(data)
      data.map { |d| CalendarImporter::Events::MeetupEvent.new(d) }
    end
  end
end
