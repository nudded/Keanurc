# Requires the ruby-github gem found at:
# http://github.com/mbleigh/ruby-github
#
require 'ruby-github'

class GitHubPlugin < Plugin

  on_command '!github' do |query, response|
    begin
      user = GitHub::API.user(query)
      c = user.repositories.last.commits.last
      link = response.dup
      response.message = "#{c.author.login} comitted to #{c.repository}: #{c.message}"
      link.message = c.url
      [response, link]
    rescue
      response.message = "fuck git, CVS is the way to go"
    end
  end

end
