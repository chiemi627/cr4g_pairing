require "securerandom"
require "csv"
require "google_drive"

class PairingsController < ApplicationController

  def index
    @data = {}
    if params[:account] && Event.exists?(account: params[:account])
      sheetURL = Event.find_by(account: params[:account])[:googlesheet]
      nonmentors,mentors = readdata_from_google_spreadsheet(sheetURL)
      @data[:pairs] = pairing_with_mentors(nonmentors,mentors)    
      session[:data] = @data      
    else
      flash.now[:warning]="イベントが登録されていません"
      redirect_to root_path and return
    end
  end

  def pair    
    @data = {}
    if params[:file] 
      if params[:file].content_type.downcase != "text/csv"
        flash.now[:warning]="CSVファイルを読み込んでください"      
        render "pair" and return
      end
      nonmentors,mentors = readdata_from_csv(params[:file].path)
      if nonmentors.size + mentors.size == 0
        flash.now[:warning]="データを正しく読み込めませんでした"
        render "pair" and return
      end
      @data[:pairs] = pairing_with_mentors(nonmentors,mentors)    
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
      if savedata.save
        flash.now[:success] = "The pairing data is saved to "+root_url(only_path: false) + name
      else
        name = SecureRandom.urlsafe_base64(8)
        savedata = PairingLog.new(name:name, data:session[:data].to_json)
        savedata.save
        flash.now[:warning] = "名前が有効でなかったので"+root_url(only_path: false)+name+"で保存しました。"
      end
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

  def pairing_with_mentors(nonmentors,mentors)
    pairs = []

    nonmentors_shfl = nonmentors.shuffle
    mentors_shfl = mentors.shuffle

    [mentors_shfl.length,nonmentors_shfl.length].min.times {
      pairs.push [nonmentors_shfl.shift,mentors_shfl.shift].sort_by{|p| p[0]}
    }
    
    rest = nonmentors_shfl + mentors_shfl

    rest.shuffle.each_slice(2) do |x, y|
      if y!=nil
        pairs.push [x,y].sort_by{|p| p[0]}
      else
        pairs.push [x,y]
      end
    end
    if rest.length % 2 == 1 then
      pairs[-2].push pairs[-1][0]
      pairs.pop
    end
    pairs.sort_by! { |pair|
      pair[0][0]
    }
    return pairs
  end

  def load_google_spreadsheet(key)
    session = GoogleDrive::Session.from_config("google_drive_config.json")
    sheet = session.spreadsheet_by_key(key).worksheets[0]
    sheet
  end

  def readdata_from_google_spreadsheet(key)
    nonmentors = []
    mentors = []
    sheet = load_google_spreadsheet(key)
    sheet.rows.each { |row|
      if valid?(row) && participate?(row)
        mentor?(row) ? mentors.push(getInfo(row)) : nonmentors.push(getInfo(row))
      end
    }
    [nonmentors,mentors]
  end

  def readdata_from_csv(filename)
    nonmentors = []
    mentors = []
    begin
      CSV.foreach(filename, headers: true) do |row|
        if valid?(row) && participate?(row)
          mentor?(row) ? mentors.push(getInfo(row)) : nonmentors.push(getInfo(row))
        end
      end
    rescue
      flash.now[:warning]="データを正しく読み込めませんでした"      
    end
    [nonmentors,mentors]
  end

  def valid?(row)
    !( row[0].blank? || row[0].to_i == 0)  
  end

  def participate?(row)
    !(row[2]=="1")
  end

  def mentor?(row)
    row[3]=="1"
  end

  def getID(row)
    row[0].to_i
  end

  def getInfo(row)
    if row[1]==""
      return [row[0],"(noname)"]
    end
    [row[0].to_i,row[1]]
  end

end
