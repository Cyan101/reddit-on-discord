require 'rest-client'
require 'json'
require 'rufus-scheduler'

# Setup a schedular
timer = Rufus::Scheduler.new

# Returning a post
def readPost(post_list, id)
  post = post_list['data']['children'][id]['data']
end

# Format the post for legibility
def formatPost(post)
  # Look at "post-info.png" for details on what's in the post array
  title = post['title']
  score = post['score']
  author = post['author']
  url = post['url']
  preview = post['preview']['images'][0]['source']['url']
  formatted_post = "`#{title}`, Score: `#{score}`, By `u/#{author}`, @ #{url}"
end

# Grab the latest post, starts at 0
timer.every '10s' do
  # Get the 5 newest posts from the subreddit and parse the json into an array
  subreddit_raw = RestClient.get('http://www.reddit.com/r/nekomimi/new.json', {params: {limit: 5}})
  newposts = JSON.parse(subreddit_raw)
  # Get the newest post
  latest_post = readPost(newposts, 0)
  # Output the latest post formatted
  latest_post['name'] == $latest ? fresh = false : fresh = true
  next unless fresh
  puts formatPost(latest_post)
  $latest = latest_post['name']
end

# Finding the last posted post

# Start the schedular
timer.join
