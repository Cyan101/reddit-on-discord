require 'rest-client'
require 'json'
require 'rufus-scheduler'
require 'cgi'
# Reddit Reading File, Not actually used by the Bot.
# Reference for making other reddit programs/tools

# Setup a schedular
timer = Rufus::Scheduler.new

# Returning a post
def read_post(post_list, id)
  post_list['data']['children'][id]['data']
end

# Format the post for legibility
def format_post(post)
  # Look at "post-info.png" for details on what's in the post array
  title = post['title']
  score = post['score']
  author = post['author']
  url = post['url']
  preview = post['thumbnail']
  "`#{CGI.unescapeHTML(title)}`, Score: `#{score}`, By `u/#{author}`, @ #{url}"
end

# Grab the latest post, starts at 0
timer.every '10s' do

  # Get the 5 newest posts from the subreddit and parse the json into an array
  user_agent = 'Ubuntu1604:Github/cyan101/reddit-on-discord/v0.2 by /u/Cyan101'
  subreddit_raw = RestClient.get("http://www.reddit.com/r/#{Config['subreddit']}/new.json", {params: {limit: 5}}, :user_agent => user_agent)
  new_posts = JSON.parse(subreddit_raw)

  # If its the first time running make the @post_ids hash
  @post_ids ||= []
  # Reset the hash of posts
  posts = []
  # Add the latest posts to the posts var
  5.times { |i| posts << read_post(new_posts, i)}
  # Send the post and save its ID if its a new post
  posts.each do |post|
    puts format_post(post) unless @post_ids.include? post['id']
    @post_ids << post['id'] unless @post_ids.include? post['id']
  end

  # Another way to wait 10 seconds between instead of a timer
  #puts '-sleep started-'
  #sleep(10)
  #puts '~sleep finished~'
end

# Start the schedular
timer.join
