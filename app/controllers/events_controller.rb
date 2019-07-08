class EventsController < ApplicationController
  def new
  end

  def create
    event = Event.new(event_params)
    if  event.save
      flash[:success] = "#{event.name}を登録しました。"+root_url(only_path: false) + "events/" + event.account + " でペアリングが自動生成されます。"
      redirect_to controller: 'pairings', action: 'index', account: event.account
    else
      flash[:danger] = "登録できませんでした。"+event.errors.full_messages.join(", ")
      redirect_to action: 'new'
    end
  end

  def event_params
    params.require(:event).permit(:name,:account,:googlesheet)
  end
end
