class UrlsController < ApplicationController
  # Render a list of all shortened URL.
  def index
    @urls = Url
      .all
      .sort_by { |url| url.full_url }
  end

  # Redirect to given shortened URL by 'id' or render 404 if missing.
  def show
    @url = Url.find(params[:id])
    redirect_to @url.full_url, allow_other_host: true
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  # Render new URL shortened form.
  def new
    @url = Url.new
  end

  # Create new shortened URL with given JSON form.
  # Example json: { "full_url": "https://42.fr/" }
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

  # Destroy given shortened URL by 'id' or render 404 if missing.
  def destroy
    @url = Url.find(params[:id])
    @url.destroy
    redirect_to urls_path, status: :see_other
  end

  private

  # Retrieve already inserted URL or compose new.
  def retrieve_existing_url_or_compose_new
    attrs = compose_url_attributes()
    Url.find_by(full_url: attrs[:full_url]) || Url.new(attrs)
  end

  # Extract required params from request and infer new shortened ID.
  def compose_url_attributes
    attrs = params.require(:url).permit(:full_url)
    attrs[:id] = new_shortened_id()
    attrs
  end

  # Spec for shortened ID are: between 6 and 10 chars.
  def new_shortened_id
    size = Random.rand(5) + 6
    Nanoid.generate(size: size)
  end

  # Compose new URL with server base URL + internal shortened URL ID.
  def shortened_url
    "#{request.base_url}/#{@url.id}"
  end
end
