# load the gem
require 'bundler/inline'
gemfile do
  source 'https://rubygems.org'
  gem 'rails',                           '>= 5.2.2.1', '~> 5.2.2'
  gem 'manageiq-messaging',              '~> 1.0.0'
  gem 'insights-api-common',             '~> 4.0'
  gem 'byebug'
end
require 'byebug'
require 'yaml'
require 'securerandom'
require 'base64'
#
# setup authorization

client = ManageIQ::Messaging::Client.open({
  :protocol => :Kafka,
  :host     => ENV["QUEUE_HOST"] || "localhost",
  :port     => ENV["QUEUE_PORT"] || "9092",
  :encoding => "json"
})

payload = { :params => {
    :source_id => "200",
    :source_uid => "8c18f2f2-7319-413f-ba3a-68bf4d487e5e",
    :external_tenant => "6089719"
  }
}
headers = {'x-rh-identity' => ENV.fetch("X-RH-IDENTITY")}

publish_opts = {
  :service => "platform.topological-inventory.operations-ansible-tower",
  :event   => "Source.availability_check",
  :headers => headers,
  :payload => payload
}

def original_url
  "http://example.com"
end

default_request = {:headers => headers.merge!('x-rh-insights-request-id' => 'gobbledygook'), :original_url => original_url }

Insights::API::Common::Request.with_request(default_request) do
  client.publish_topic(publish_opts)
end
