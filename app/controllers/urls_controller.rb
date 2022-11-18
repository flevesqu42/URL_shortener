class UrlsController < ApplicationController
  # Redirect to given shortened URL by 'id' or render 404 if missing.
  def redirect
    @url = Url.find(params[:id])
    redirect_to @url.full_url, allow_other_host: true
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Render new URL shortened form.
  def new
    @url = Url.new
  end

  # Render new URL shortened form prefiled with given URL data
  def show
    @url = Url.find(params[:id])
    @new_shortened_url = redirect_url()

    # refresh URL form and render
    @url = Url.new(full_url: @url.full_url)
    render :new
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Create new shortened URL with given JSON form.
  # Example json: { "url": { "full_url": "https://42.fr/" } }
  def create
    @url = retrieve_existing_url_or_compose_new()
    if @url.save
      redirect_to url_path(@url)
    else
      logger.debug("Failed to save URL: #{@url.errors.full_messages}")
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Check if new generated URL is already inserted, otherwise return new one
  def retrieve_existing_url_or_compose_new
    attrs = compose_url_attributes()
    Url.find_by(full_url: attrs[:full_url].strip) || Url.new(attrs)
  end

  # Extract required params from request and infer new shortened ID.
  def compose_url_attributes
    params.require(:url).permit(:full_url)
  end

  # Compose new URL with server base URL + internal shortened URL ID.
  def redirect_url
    "#{request.base_url}#{redirect_path(@url)}"
  end
end
