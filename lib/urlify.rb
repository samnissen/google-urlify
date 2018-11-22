require 'json'
require 'uri'

class URLify
  class << self
    def find(string)
      setup

      browser.text_field(type: "text").set(URI.decode(string))
      browser.button(aria_label: "Google Search").click
      doc = Nokogiri::HTML(browser.div(id: "rso").div(class: "g").html)
      link = doc.css('a').first.attributes["href"].value

      return {result: link}.to_json

    ensure
      @b.close rescue nil
      @b = nil
    end

    private
      def setup
        dismiss_data_popup
        first_google_search
      end

      def dismiss_data_popup
        return unless browser.iframe(src: /\:\/\/consent.google.com/).present?
        browser.link(href: /\.\/ui\/\?continue\=/).click
        browser.goto "https://policies.google.com/privacy?hl=en&gl=gb#infochoices"
      end

      def first_google_search
        browser.goto "https://google.com"
        browser.text_field(type: "text").set("hello")
        browser.buttons.map{|b| b if b.value == "Google Search" && b.located?}.compact.last.click
      end

      def browser
        if !@b
          options = { args: ['--no-sandbox', '--headless'] }
          @b = Watir::Browser.new :chrome, options: options
          setup
        end

        @b
      end
  end
end
