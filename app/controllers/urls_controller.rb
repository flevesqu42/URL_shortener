class UrlsController < ApplicationController
  def index
    @urls = Url
      .all
      .sort_by { |url| url.full_url }
  end

  def show
    begin
      url = Url.find(params[:id])
      redirect_to url.full_url, allow_other_host: true
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end

  def new
    @url = Url.new
  end

  def create
    @url = Url.new(url_params)
    if @url.save
      @shortened_url = shortened_url
      logger.debug("New URL: #{@shortened_url}")
      render :new, status: :created
    else
      logger.debug("Failed to save URL: #{@url.errors.full_messages}")
      render :new, status: :unprocessable_entity
    end
  end

  private
  def url_params
    req = params.require(:url).permit(:full_url)
    req["id"] = shortened_id
    req
  end

  private
  def shortened_id
    size = Random.rand(4) + 6
    Nanoid.generate(size: size)
  end

  private
  def shortened_url
    "#{request.base_url}/#{@url.id}"
  end
end
