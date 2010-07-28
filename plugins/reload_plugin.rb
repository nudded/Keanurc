class ReloadPlugin < Plugin
 
  on_command '!reload' do |query, response|
    if query.empty?
      Plugin.reload
      response.message = "reloaded all my plugins"
      response
    end
  end


end
