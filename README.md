# Reddit-On-Discord

Simple discord bot built in ruby, outputs any new posts on a subreddit to a specific channel (Made for image subreddits like /r/Aww).
Checks the [5 latest posts](https://github.com/Cyan101/reddit-on-discord/blob/master/bot.rb#L46) every [10 seconds](https://github.com/Cyan101/reddit-on-discord/blob/master/bot.rb#L44) (Change this depending on your needs)

## Installation

From the Repo
1. Clone the Repo `git clone https://github.com/cyan101/reddit-on-discord.git`
2. `cd reddit-on-discord`
3. Delete the .git folder `rm -rf .git` and start your own repo `git init`
4. Install all the required shards `bundle` (if you don't have it yet use `gem install bundler`)

## Usage

From the Repo
1. Create a dev app (and then a bot user) at [Discord Dev -> My Apps](https://discordapp.com/developers/applications/me)
2. Make `config.yaml`
3. Add the bot to your server `https://discordapp.com/oauth2/authorize?&client_id=xxx&scope=bot` replace `xxx` with your client ID
4. Run `ruby bot.rb`, alternatively use a proccess manager like [PM2](http://pm2.keymetrics.io/) to run it in the background

### Example Config
```
---
  bot_key: a7S2-------------ZD4
  bot_id: 33------53
  bot_vers: 0.1
  channel: 2432-------216
  owner: 141--------704
  subreddit: aww
  bot_name: /r/Aww Posts
```

## Contributing

1. Fork it ( https://github.com/cyan101/reddit-on-discord/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Cyan101](https://github.com/cyan101) Jos Spencer - creator, maintainer
