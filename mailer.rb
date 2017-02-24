require 'sinatra'
require 'pony'

before do
    headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Origin']  = '*'
    headers['Access-Control-Allow-Headers'] = 'accept, authorization, origin'
end

# whitelist should be a space separated list of URLs
set :protection, :origin_whitelist => ENV['WHITELIST'].split

Pony.options = {
  :via => :smtp,
  :via_options => {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}

get '/' do
  redirect to(ENV['HOME'])
end

post '/' do
  email = ""
  params.each do |value|
    email += "#{value[0]}: #{value[1]}\n"
  end
  puts email
  Pony.mail(
    :to => ENV['EMAIL_RECIPIENTS'],
    :from => ENV['EMAIL_FROM'],
    :subject => "New Contact Form (#{ENV['HOME']})",
    :body => email
  )
end
