require 'discordrb'
require 'rest-client'
require 'json'
require 'rufus-scheduler'
require 'cgi'
require 'yaml'
require 'time'

# Load the config var's and create the bot using them
Config = YAML.load_file('config.yaml')
Bot = Discordrb::Commands::CommandBot.new token: Config['bot_key'], client_id: Config['bot_id'], prefix: '~'

puts "Loading Reddit-On-Discord v#{Config['bot_vers']}"
puts "Invite URL: #{Bot.invite_url}"

# Return a specific post
def readPost(post_list, id)
  post = post_list['data']['children'][id]['data']
end

# Format and Send a post to the discord channel
def sendPost(post)
  title = CGI.unescapeHTML(post['title'])
  author = post['author']
  url = post['url']
  time = post['created']
  link = 'https://reddit.com' + post['permalink']
  preview = post['preview']['images'][0]['source']['url']
  # Create an Embed
  Bot.channel(Config['channel']).send_embed do |emb|
    emb.color = '3498db'
    emb.author = { name: title, url: link}
    emb.image = { url: preview }
    emb.url = link
    emb.add_field name: 'Link:', value: url, inline: false
    emb.footer = { text: "Posted by /u/#{author} @ #{Time.at(time).strftime('%a, %d %b %H:%M')}", icon_url: Bot.profile.avatar_url }
  end
end

# Setup a schedular
timer = Rufus::Scheduler.new

# Grab the latest post, starts at 0
timer.every '10s' do
  # Get the 5 newest posts from the subreddit and parse the json into an array
  subreddit_raw = RestClient.get("http://www.reddit.com/r/#{Config['subreddit']}/new.json", {params: {limit: 5}})
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
    sendPost(latest_post)
  end

  # Save the latest post's ID
  latest_post = readPost(new_posts, 0)
  $latest = latest_post['name']
end

# Start the schedular (Causes issues for some reason?!?)
#timer.join
Bot.ready do |event|
  # Set the bots name from the config
  Bot.profile.username = Config['bot_name']
end

Bot.command(:eval, help_available: false) do |event, *code|
  break unless event.user.id == Config['owner']
  begin
    eval code.join(' ')
  rescue => e
    "It didn't work :cry: sorry.... ```#{e}```"
  end
end

# Start the Bot
Bot.run
