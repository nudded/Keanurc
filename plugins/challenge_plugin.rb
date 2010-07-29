
class ChallengePlugin < Plugin
  
  def self.questions
    {"who sucks?" => "reeeelix"}
  end
  
  class << self
    attr_accessor :challenged, :challengers, :q
  end

  on_command '!challenge' do |query, response, sender|
    unless query.empty?  
      self.challenged = true
      self.challengers = [query, sender] 
      question = response.dup
      response.message = "Ok #{query} and #{sender} here's the question:"
      self.q = questions.keys.sample
      question.message = q
      [response, question]
    end
  end

  def on_privmsg(command)
    if self.class.challenged && self.class.challengers.any? {|c| c == command.sender}
      puts "TEST"
      if command.message == self.class.questions[self.class.q] 
        self.class.challenged = false
        res = respond(command)
        res.message = command.sender + " wins the day" 
        return res
      end
    else
      super
    end
  end

end
