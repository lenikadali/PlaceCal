# frozen_string_literal: true

# In order for a parser to be recognized, it must be added
# to the PARSERS constant list in app/models/calendar_parser.rb.
# Parent parser classes should not be added.

module CalendarImporter::Parsers
  class Ics < Base
    # These constants are only used for the frontend interface
    NAME = 'Generic iCal / .ics'
    DOMAINS = %w[
      calendar.google.com
      outlook.office365.com
      outlook.live.com
      ics.teamup.com
      webcal://
    ]

    def self.whitelist_pattern
      whitelists = {
        gcal: %r{http(s)?://calendar.google.com\.*},
        outlook: %r{http(s)?://outlook.(office365|live).com/owa/calendar/.*},
        webcal: %r{webcal://},
        mossley: %r{http(s)?://mossleycommunitycentre.org.uk},
        theproudtrust: %r{http(s)?://www.theproudtrust.org},
        teamup: %r{http(s)?://ics.teamup.com/feed/.*},
        consortium: %r{https://www.consortium.lgbt/events/.*}
      }
      Regexp.union(whitelists.values)
    end

    def download_calendar
      # Why are we doing this?
      url = @url.gsub(%r{webcal://}, 'https://') # Remove the webcal:// and just use the part after it
      HTTParty.get(url, follow_redirects: true)
    end

    def import_events_from(data)
      @events = []

      # It is possible for an ics file to contain multiple calendars
      Icalendar::Calendar.parse(data).each do |calendar|
        calendar.events.each do |event|
          # Date can't be parsed with calling `value_ical` first
          @start_time = DateTime.parse(event.dtstart.value_ical) if event.dtstart
          @end_time = DateTime.parse(event.dtend.value_ical) if event.dtend

          @events << CalendarImporter::Events::IcsEvent.new(event, @start_time, @end_time)
        end
      end

      @events
    end

    def digest(data)
      # read file to get contents before creating digest
      Digest::MD5.hexdigest(data)
    end
  end
end