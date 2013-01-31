require "scrunchie/version"
require "faraday"

module Scrunchie
  class Blast
    attr_accessor :username, :api_key, :listname

    # Take optional username, api_key, and listname and assign them to instance variables,
    # or obtain those information from the environment if set.
    def initialize(username=nil, api_key=nil, listname=nil)
      @username = username || ENV['USERNAME']
      @api_key = api_key || ENV['API_KEY']
      @listname = listname || "Charm"
      @obj = Faraday.new('https://api.elasticemail.com/lists')
      @auth = { username: @username, api_key: @api_key }
    end

    # Create email in the database.
    def create_contact(params={})
      @obj.post('create-contact', @auth.merge(params))
    end

    # Delete email from the database.
    def delete_contact(params={})
      @obj.delete('delete-contact', @auth.merge(params))
    end

    # Create an empty list.
    def create_list(params={})
      @obj.post('create-list', @auth.merge(params))
    end

    # Delete a list, but does not remove contacts.
    def delete_list(params={})
      @obj.delete('delete', @auth.merge(params))
    end

    # Add an email already in the database to a listname.  Returns error if no email.
    def add_contact(params={})
      @obj.put('add-contact', @auth.merge(params))
    end

    # Remove an email from a list, but does not delete the email.
    def remove_contact(params={})
      @obj.put('remove-contact', @auth.merge(params))
    end

    # This is not tested yet.
    # Theoretically can upload a CSV of contact emails with optional fields
    def upload_contacts(params={})
      @obj.post('upload-contacts', @auth.merge(params)) # file: UploadIO.new(filepath, 'text/csv')
    end

    # Returns XML message constructed as { lists: { list: [{ name: "listname", contact: number }, { ... }] }.
    def get_lists
      @obj.get('get', @auth)
    end

    # Get a list of emails with possible firstname and lastname attributes from the list.
    def get_contacts(params={})
      @obj.get('get-contacts', @auth.merge(params))
    end

    # Get a CSV file containing all the contacts from @listname.
    def download(format=nil)
      if format == 'csv'
        @obj.get('download', @auth.merge(format: format))
      else
        @obj.get('download', @auth)
      end
    end
  end

  module XML
    class << self
      # Attemps to parse the body, and rescue the ParseError to do the right thing 
      def parse(body)
        begin
          MultiXml.parse(body)
        rescue MultiXml::ParseError => body
          convert_to_hash(body)
        end
      end

      def convert_to_hash(body)
        if body.start_with?("Error")
          return { "Error" => body }
        else
          return { "Other" => body }
        end
      end
    end
  end
end
