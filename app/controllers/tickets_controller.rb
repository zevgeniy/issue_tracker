class TicketsController < ApplicationController
  before_filter :authenticate_user!, only: [:index]

  before_action :set_ticket, only: [:show, :edit, :update, :history]

  def index
    @tickets = Ticket.all.includes(:user)
    @tickets = @tickets.where(status: params[:status]) if params.include?(:status)
    @tickets = @tickets.where("token = :param OR subject = :param", param: params[:q]) if params.include?(:q)
  end

  def show

  end

  def new
    @ticket = Ticket.new
  end

  def edit
  end

  def create
    @ticket = Ticket.new(ticket_params)
    @ticket.user = current_user if user_signed_in?

    if @ticket.save
      redirect_to @ticket, notice: 'Ticket was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: 'Ticket was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def history

  end

private
  def redirect_to_new
    redirect_to new_ticket_path unless user_signed_in?
  end

  def set_ticket
    @ticket = Ticket.find_by!(token: params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:customer_name, :customer_email, :subject, :department, :body)
  end
end
