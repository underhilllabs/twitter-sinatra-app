require 'rubygems'
require 'sinatra/base'
require 'twitter'
require 'dotenv'
Dotenv.load

class MyApp < Sinatra::Base
  before do 
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["consumer_key"]
      config.consumer_secret     = ENV["consumer_secret"]
      config.access_token        = ENV["access_token"]
      config.access_token_secret = ENV["access_token_secret"]
    end
  end

  get "/" do
    expires 3600, :public, :must_revalidate
    followers = @client.followers
    friends = @client.following
    follower_ids = followers.collect { |f| f.id }
    friends_ids = friends.collect { |f| f.id }
    @nonfollowers = friends.reject{|f| follower_ids.include? f.id }
    @nonfollowing = followers.reject{|f| friends_ids.include? f.id }
    erb :index
  end
end
