require 'set'
class MessagesController < ApplicationController
  
  @@usernames_db = Hash.new
  
  def initialize
    prepare_username_db 
    super
  end

  def create    
    username = params[:message][:username]
    suggested_username = suggest_username username
    
    if username != suggested_username
      @message = Message.new(params.require(:message).permit(:message, :username))
      flash[:suggested_username] = suggested_username
    else
      @message = Message.create!(params.require(:message).permit(:message, :username))
      @message.save
      add_username_to_db(username)
    end

    @message
    @messages = Message.paginate(page: params[:page], per_page: 20)
    redirect_to freedomwall_index_path
  end

  def prepare_username_db
    if @@usernames_db.length == 0
      messages = Message.all
      messages.each do |message|
        add_username_to_db(message.username)
      end
    end
    @@usernames_db
  end

  def add_username_to_db(username)
    pattern = /([a-zA-Z]+)(\d*)/
    if username =~ pattern
      base = $1
      if $2.empty?
        suffix = -1
      else
        suffix = $2.to_i
      end
      if @@usernames_db.has_key? base
        @@usernames_db[base].add(suffix)
      else
        @@usernames_db[base] = SortedSet.new.add(suffix)
      end
    end
    @@usernames_db
  end

  def suggest_username(input)
    pattern = /([a-zA-Z]+)(\d*)/
    if input =~ pattern
      base = $1
      if $2.empty?
        suffix = -1
      else
        suffix = $2.to_i
      end

      if !@@usernames_db.has_key?(base)
        return base
      else
        suffixes = @@usernames_db[base]
        if suffixes.include?(suffix)
          if !suffixes.include?(-1)
            return base
          else
            suffix += 1
            if suffix == 0
              suffix += 1
            end
            while suffixes.include?(suffix) do
              suffix += 1
            end
            return base + suffix.to_s
          end
        else
          return input
        end
      end
    end
  end
end
