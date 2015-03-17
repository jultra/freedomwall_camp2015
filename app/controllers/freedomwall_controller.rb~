require 'set'

class FreedomwallController < ApplicationController
  # set per_page globally
  #WillPaginate.per_page = 30

  def index
    @messages = Message.paginate(page: params[:page], per_page: 20)
  end

  def create
    keyword = params[:search][:keyword]
    @messages = Message.where("username like :keyword or message like :keyword",
                      {:keyword => "%#{keyword}%"}).
                      paginate(page: params[:page], per_page: 20)
      
    render 'freedomwall/index'
  end
end
