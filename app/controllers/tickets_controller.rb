class TicketsController < ApplicationController
  before_action :set_ticket, only: %i[show edit update destroy toggle_resolve toggle_public public_show]

  load_and_authorize_resource

  def index
    @tickets = @tickets.includes(:submitter).order_by_submission.page(params[:page]).per(20)
    
    @tickets = @tickets.where(submitter_id: current_user.id).page(params[:page]).per(20) if current_user.member?
  end

  def show; end

  def new
    @ticket = Ticket.new
  end

  def create
    @ticket = current_user.submitted_tickets.create(ticket_params)

    if @ticket.save
      redirect_to @ticket, notice: 'Ticket created successfully.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @ticket.update(ticket_params)
      redirect_to @ticket, notice: 'Ticket updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @ticket.destroy
    redirect_to tickets_path
  end

  def toggle_resolve
    @ticket.update(resolved: !@ticket.resolved)
    redirect_to @ticket
  end

  def toggle_public
    if @ticket.answer.present?
      @ticket.update(public: !@ticket.public)
      redirect_to public_show_ticket_path(@ticket), notice: 'Successfully set ticket as FAQ'
    else
      render :show, alert: 'FAQ tickets must have an answer'
    end
  end

  def faq
    @tickets = Ticket.includes(:topics).public.search(params[:query]).order_by_submission.page(params[:page]).per(10)
  end

  def public_show; end

  def pending
    @tickets = @tickets.unresolved.includes(:submitter).order_by_submission.page(params[:page]).per(20)

    @tickets = @tickets.unresolved.where(submitter_id: current_user.id).page(params[:page]).per(20) if current_user.member?

    render :index
  end

  def resolved
    @tickets = @tickets.resolved.includes(:submitter).order_by_submission.page(params[:page]).per(20)

    @tickets = @tickets.resolved.where(submitter_id: current_user.id).page(params[:page]).per(25) if current_user.member?

    render :index
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    params.require(:ticket).permit(:title,
                                   :description,
                                   :attachment,
                                   :query,
                                   topic_ids:[],
                                   topics_attributes: %i[name _destroy id])
  end
end
