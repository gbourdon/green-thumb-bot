require 'discordrb' #What makes the bot work
require 'configatron' #Allows config files
require_relative 'config.rb' #Loads the config file

bot = Discordrb::Commands::CommandBot.new token: configatron.token, client_id: 319888400326983680, prefix: '.' #Sets up the bot

# Here we output the invite URL to the console so the bot account can be invited to the channel.
puts "This bot's invite URL is #{bot.invite_url}."
puts 'Click on it to invite it to your server.'

=begin
This method call adds an event handler that will be called on any message that exactly contains the string "Ping!".
The code inside it will be executed, and a "Pong!" response will be sent to the channel.
bot.message(content: 'Ping!') do |event|
  event.respond 'Pong!'
end

Scrapyard: (Stuff that I might use later on)
required_permissions: [:ban_members]
=end

bot.command(:about, description: "Tells a bit about the bot") do #Tells a bit about the bot.
    "Hello.
I am **GreenThumb**, a bot in discordrb created by the one and only gustav341. 
Why? For world domination, of course!
(Actually, it's to do some useful stuff)
If you want to use me, do .help" #Tells you about the bot
end

bot.command(:ping, description: "Sends a pong if the bot is responding.", permission_level: 0) do #Quick sanity check to see if the bot is working
    #puts "Recieved a ping!" #Lets the console know all is well
    m = event.respond('Pong!') #Responds with Pong!
    m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds." #Updates with some useful stuff
    
end

bot.command(:clear, description: "Syntax: .clear n\nClears out n messages.", permission_level: 0, required_permissions: [:manage_messages]) do |event, num| #Clears n messages, including itself
    num = num.to_i #Turns the string into something you can work with
    num += 1 #Includes the orgin message
    event.channel.prune(num) #Prunes (clears) num messages.
end

bot.command(:ban, description: "Syntax: .ban <user> <reason>\nBans <user> for <reason>", permission_level: 0, required_permissions: [:ban_members]) do |event, mention, *reason| #Bans a mentioned member
    member = event.bot.parse_mention(mention) #Converts the mention into a USER object
    if event.user == member #Stops the user from inadvertently banning themselves
      event.respond("Stop banning yourself, #{mention}")
      break
    end
    #event.server.ban(member, 0, reason: reason.join(" ")) #Doesen't work RN, hope it works in the next update
    event.server.ban(member) #Bans the User
    event.respond reason == [] ? "Banned #{mention}" : "Banned #{mention} for #{reason.join(" ")}" #Informs the person that the use has been kicked
    #TODO: Rename the member variables to user in Ban and Kick to avoid logic errors.
end

bot.command(:kick, description: "Syntax: .kick <user> <reason>\nBans <user> for <reason>", permission_level: 0, required_permissions: [:kick_members]) do |event, mention, *reason| #Kicks a mentioned member
    member = event.bot.parse_mention(mention) #Converts the mention into a USER object
    if event.user == member #Stops the user from inadvertently kicking themselves
        event.respond("Stop kicking yourself, #{mention}")
        break
    end
    #event.server.kick(member, reason.join(" "))
    event.server.kick(member) #Kickes the user
    event.respond reason == [] ? "Kicked #{mention}" : "Kicked #{mention} for #{reason.join(" ")}" #Informs the person that the user has been kicked
end


bot.ready do #When the bot is initalised
    bot.game = (".help") #Sets the "Playing" screen to '.help'
end

bot.command(:roleid, permission_level: 0, description: "Syntax: .roleid Rolename\nReturns the role id of Rolename.") do |event, *id| #Returns the Role's id
    id = id.join(" ")
    roles = event.server.roles
    roles = roles.select{ |role| role.name == id }
    roles.each do |role|
        event.respond "#{role.name}: #{role.id}"
    end
    return nil
end

bot.run 
