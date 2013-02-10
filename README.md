# Scrunchie

This gem interfaces with the Elastic Email's API at <http://www.elasticemail.com>.

## Installation

Add this line to your application's Gemfile:

    gem 'scrunchie'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install scrunchie

## Example Usage

Set the configuration in a file that is loaded by Rails autoload path or create a new folder in app/
and set create a class to hold the email address you register at Elastic Email and the API key.

    class CharmBlast
      def initialize(params)
        @params = params
        @faraday = Scrunchie::Blast.new('your-email@address.com', 'your-authentication-token', 'Name of List')
      end

      def deliver
        @resp = @faraday.create_contact(@params)
        @parsed = Scrunchie::XML.parse(@resp.body)
      end
    end

Get the response:

    @resp = CharmBlast.new(email: 'email@address.com', first_name: 'email', last_name: 'address').deliver

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
