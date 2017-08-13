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
def read_post(post_list, id)
  post = post_list['data']['children'][id]['data']
end

# Format and Send a post to the discord channel
def send_post(post)
  title = CGI.unescapeHTML(post['title'])
  author = post['author']
  url = post['url']
  time = post['created']
  link = 'https://reddit.com' + post['permalink']
  preview = post['thumbnail']
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

Bot.command(:reddit) do
@running = true
while @running do
  # Get the 5 newest posts from the subreddit and parse the json into an array
  subreddit_raw = RestClient.get("http://www.reddit.com/r/#{Config['subreddit']}/new.json", {params: {limit: 5}})
  new_posts = JSON.parse(subreddit_raw)

  # For each new post: Grab it, Format it and Output it
  #counter.times do |i|
    #latest_post = read_post(new_posts, i)
   # send_post(latest_post)
  #end

  @posts_id ||= []
  posts = []
  5.times { |i| posts << read_post(new_posts, i)}
  posts.each do |post|
    send_post(post) unless @posts_id.include? post['id']
    @posts_id << post['id']
  end
  puts '-sleep started-'
  sleep(10)
  puts '~sleep finished~'
end
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
