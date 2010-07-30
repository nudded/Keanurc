class ReloadPlugin < Plugin
 
  on_command '!reload' do |query, response|
    if query.empty?
      Plugin.reload
    end
  end


end
