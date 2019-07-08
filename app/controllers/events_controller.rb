class EventsController < ApplicationController
  def new
  end

  def create
    event = Event.new(event_params)
    event.save
    flash[:success] = "#{event.name}を登録しました。"+root_url(only_path: false) + "events/" + event.account + " でペアリングが自動生成されます。"
    redirect_to controller: 'pairings', action: 'index', account: event.account
  end

  def event_params
    params.require(:event).permit(:name,:account,:googlesheet)
  end
end
