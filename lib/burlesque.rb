require "burlesque/version"

class ElasticError < StandardError
end

module Burlesque
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
    def create_contact(email, optional_hash={})
      @obj.post('create-contact', @auth.merge(optional_hash)
    end

    # Delete email from the database.
    def delete_contact(email)
      @obj.delete('delete-contact', @auth.merge(email: email))
    end

    # Create an empty list.
    def create_list(listname)
      @obj.post('create-list', @auth.merge(listname: listname))
    end

    # Delete a list, but does not remove contacts.
    def delete_list(listname)
      @obj.delete('delete', @auth.merge(listname: listname))
    end

    # Add an email already in the database to a listname.  Returns error if no email.
    def add_contact(email, listname)
      @obj.put('add-contact', @auth.merge(email: email, listname: listname))
    end

    # Remove an email from a list, but does not delete the email.
    def remove_contact(email, listname)
      @obj.put('remove-contact', @auth.merge(email: email, listname: listname))
    end

    # This is not tested yet.
    # Theoretically can upload a CSV of contact emails with optional fields
    def upload_contacts(filepath, listname)
      @obj.post('upload-contacts', @auth.merge(listname: listname, file: UploadIO.new(filepath, 'text/csv')))
    end

    # Returns XML message constructed as { lists: { list: [{ name: "listname", contact: number }, { ... }] }.
    def get_lists
      @obj.get('get', @auth)
    end

    # Get a list of emails with possible firstname and lastname attributes from the list.
    def get_contacts
      @obj.get('get-contacts', @auth)
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

  class XML
    # Check if @body starts with Error and raise ElasticError
    # else try to parse using MultiXml.
    def parse(body)
      if body.start_with?("Error")
        raise ElasticError, body[6..-1]
      else
        begin
          MultiXml.parse(body)
        rescue MultiXML::ParseError
          raise ElasticError, body
        end
      end
    end
  end
end
