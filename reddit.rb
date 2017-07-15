require 'rest-client'
require 'json'
require 'rufus-scheduler'
require 'cgi'
# Reddit Reading File, Not actually used by the Bot.
# Reference for making other reddit programs/tools


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
  formatted_post = "`#{CGI.unescapeHTML(title)}`, Score: `#{score}`, By `u/#{author}`, @ #{url}"
end

# Grab the latest post, starts at 0
timer.every '10s' do
  # Get the 5 newest posts from the subreddit and parse the json into an array
  subreddit_raw = RestClient.get('http://www.reddit.com/r/nekomimi/new.json', {params: {limit: 5}})
  new_posts = JSON.parse(subreddit_raw)

  # Check for the amount of new posts
  counter = 0
  new_posts['data']['children'].each do |value|
    break if value['data']['name'] == $latest
    counter += 1
  end

  # Exit out now if the counter is empty
  next if counter == 0

  # For each new post: Grab it, Format it and Output it
  counter.times do |i|
    latest_post = readPost(new_posts, i)
    puts formatPost(latest_post)
  end

  # Save the latest post's ID
  latest_post = readPost(new_posts, 0)
  $latest = latest_post['name']
end

# Finding the last posted post

# Start the schedular
timer.join
