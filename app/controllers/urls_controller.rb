class UrlsController < ApplicationController
  # render a list of all shortened URL
  def index
    @urls = Url
      .all
      .sort_by { |url| url.full_url }
  end

  # redirect to given shortened URL by 'id' or render 404 if missing
  def show
    begin
      url = Url.find(params[:id])
      redirect_to url.full_url, allow_other_host: true
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end

  # render new URL shortened form
  def new
    @url = Url.new
  end

  # create new shortened URL with given JSON form
  def create
    @url = retrieve_existing_url_or_compose_new()
    if @url.save
      # update new shortened URL
      @new_shortened_url = shortened_url()
      logger.debug("New URL: #{@new_shortened_url}")

      # refresh URL form and render
      @url = Url.new(full_url: @url.full_url)
      render :new, status: :created
    else
      logger.debug("Failed to save URL: #{@url.errors.full_messages}")
      render :new, status: :unprocessable_entity
    end
  end

  # retrieve already inserted URL or compose new
  private
  def retrieve_existing_url_or_compose_new()
    attrs = compose_url_attributes()
    Url.find_by(full_url: attrs[:full_url]) || Url.new(attrs)
  end

  # extract required params from request and infer new shortened ID
  private
  def compose_url_attributes
    req = params.require(:url).permit(:full_url)
    req["id"] = shortened_id()
    req
  end

  # spec for shortened ID are: between 6 and 10 chars
  private
  def shortened_id
    size = Random.rand(5) + 6
    Nanoid.generate(size: size)
  end

  # compose new URL with server base URL + internal shortened URL ID
  private
  def shortened_url
    "#{request.base_url}/#{@url.id}"
  end
end
