class RR2Plugin < Plugin
  
  on_command 'rr2' do |query, command, sender|
    player = query.split.first

    kick = Command::KICK.new
    kick.channel = command.receiver

    users = [player, sender]
    kick.user = users.sample

    times = 0 
    if kick.user = player
      times = [1,3,5].sample 
    else
      times = [0,2,4].sample
    end

    dup = command.dup 
    command.message = "*RR* #{sender} challenges #{player} to russian roulette."

    array = [command]

    times.time do |i|
      new_message = dup.dup
      new_message.message = "*RR* #{users[i % 2]} takes the gun: *CLICK*"
      array << new_message
      array << sleep(0.7)
    end
    
    dup.message = "*RR* #{kick.user} takes the gun: *BANG*"
    array << dup 
    array << kick
    array
  end

end
