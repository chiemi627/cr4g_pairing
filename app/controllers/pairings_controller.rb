require "securerandom"
require "csv"
require "google_drive"

class PairingsController < ApplicationController

  def index
    @data = {}

    participants,mentors = readdata_from_google_spreadsheet("1TZCxBByvUiXRt71v8cQsVkdI356kAg19Gsh3U_OSs30")
    @data[:pairs] = pairing_with_mentors(participants,mentors)    
    session[:data] = @data      
  end

  def pair    
    @data = {}

    if params[:file] 
      if params[:file].content_type.downcase != "text/csv"
        flash[:error] = "CSVファイルをアップロードしてください"
        render
      end
      participants,mentors = readdata_from_csv(params[:file].path)
      @data[:pairs] = pairing_with_mentors(participants,mentors)    
    end
    session[:data] = @data    
  end

  def save
    if session[:data] then
      if params[:name].blank?
        name = SecureRandom.urlsafe_base64(8)
      else
        name = params[:name]
      end
      savedata = PairingLog.new(name:name, data:session[:data].to_json)
      savedata.save
      flash.now[:success] = "The pairing data is saved to "+root_url(only_path: false) + name
      @data = session[:data].with_indifferent_access
      render "show"
    end

  end

  def show
    if params[:id] then
      log = PairingLog.where(name: params[:id]).order(created_at: :desc).first
      if log then
        @data = JSON.parse(log.data).with_indifferent_access
        logger.debug(@data)
      else
        @data = {}
      end
    end
  end

  def pairing_with_mentors(participants,mentors)
    pairs = []

    nonmentors_shfl = (participants - mentors).shuffle
    mentors_shfl = mentors.shuffle

    [mentors_shfl.length,nonmentors_shfl.length].min.times {
      pairs.push [nonmentors_shfl.shift,mentors_shfl.shift].sort
    }
    
    rest = participants - pairs.flatten

    rest.shuffle.each_slice(2) do |x, y|
      if y!=nil
        pairs.push [x,y].sort
      else
        pairs.push [x,y]
      end
    end
    if rest.length % 2 == 1 then
      pairs[-2].push pairs[-1][0]
      pairs.pop
    end
    pairs.sort_by! { |pair|
      pair[0]
    }
    return pairs
  end

  def load_google_spreadsheet(key)
    session = GoogleDrive::Session.from_config("google_drive_config.json")
    sheets = session.spreadsheet_by_key(key).worksheets[0]
    sheets
  end

  def readdata_from_google_spreadsheet(key)
    participants = []
    mentors = []
    sheet = load_google_spreadsheet(key)
    (1..sheet.num_rows).each do |row|
      next if sheet[row,1].blank?
      id = sheet[row,1].to_i
      next if id==0 #to_iは不正な値を0にして返す。IDは1以上の整数なので0の場合はおかしな行と判定
      unless sheet[row,3]=="1"
        participants.push id
        mentors.push id if sheet[row,2]=="1"
      end
    end      
    [participants,mentors]
  end

  def readdata_from_csv(filename)
    participants = []
    mentors = []
    CSV.foreach(filename, headers: true) do |row|
      next if row[0].blank?
      id = row[0].to_i
      next if id==0 #to_iは不正な値を0にして返す。IDは1以上の整数なので0の場合はおかしな行と判定
      unless row[2]=="1"
        participants.push id
        mentors.push id if row[1]=="1"
      end
    end
    [participants,mentors]
  end

end
