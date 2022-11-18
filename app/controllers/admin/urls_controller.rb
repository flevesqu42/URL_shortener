class Admin::UrlsController < ApplicationController
  # Render a list of all shortened URL.
  def index
    @urls = Url
      .all
      .sort_by { |url| url.full_url }
  end

  # Destroy given shortened URL by 'id' or render 404 if missing.
  def destroy
    @url = Url.find(params[:id])
    @url.destroy
    redirect_to admin_urls_path, status: :see_other
  end
end
