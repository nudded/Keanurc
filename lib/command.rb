require_relative 'command_base'

module Command

  def self.create(name, &b)
    # create a new class
    new_class = Class.new CommandBase
    # the class will be a inside the Command module
    Command.const_set(name.upcase, new_class)
    # this adds all of the below defined methods to this class
    new_class.extend(Command)

    new_class.instance_eval(&b) if block_given?

    # now we can define the to_irc method
    new_class.send(:define_method, :to_irc) do
      param = self.class.params.inject [] do |array, pair| 
        array << pair[1].call(self.send(pair[0]))
      end.join ' ' 
      # closures are awesome
      name.upcase + ' ' + param
    end
  end
  
  def param(*names, &b)
    names.each do |name|
      Param.new self, name, &b
    end
  end
  
  # nice and handy convenience method
  def comma_separated_array(*names)
    names.each do |name|
      param name do
        default []
        join do |arr|
          arr.join ','
        end
      end
    end
  end
  
  def parse(parse_string)
    arr = parse_string.split 
    index = arr.index ':'
    arr.delete_at index if index
    # it will parse the irc string based on the given
    # parse_string. This will set the instance variables according to
    # the names specified in the parse_string
    self.send(:define_method, :parse_irc_input) do |string|
      irc_arr = string.split
      if index
        # we must not forgot to prefix the last message with a ':'
        # strip leading ':'
        key = arr[index].dup.tap {|s| s[0]=''}.to_sym
        self.class.params[key] = lambda {|v| ':' + (v ? [v].flatten.join(' ') : '')}

        # join all the components of the ending parameter together
        end_message = irc_arr.slice!(index, irc_arr.length - index).join ' '
        # strip the leading ':'
        end_message[0] = ''

        # now put it in as one string
        irc_arr << end_message
      end
      arr.zip(irc_arr).each do |k, v|
        next if v.nil?
        name = k.match(/\[?:(\w*)/)[1]
        v = v.split ',' if k[0] == '['
        send(name + '=', v)
      end
    end
  end

  # handle the creation of params
  class Param
    
    def initialize(klass, name, &b)
      klass.send(:attr_accessor, name) 

      # add a default lambda to the params hash
      klass.params[name] = lambda {|v| v}
      
      # set the current name and class so we can use it
      # when the block is eval'ed
      @klass, @name = klass, name
      instance_eval &b if block_given?
    end
  
    def default(default_value)
      name = "@" << @name
      @klass.send(:define_method, @name) do 
        value = instance_variable_get(name) 
        instance_variable_set(name, default_value) unless value  
        instance_variable_get(name) 
      end
    end
    
    def join(&b)
      warn "only 1 argument will be given" if b.arity > 1
      @klass.params[@name] = b 
    end

  end

end
