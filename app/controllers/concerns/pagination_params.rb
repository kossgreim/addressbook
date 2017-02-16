module PaginationParams
  extend ActiveSupport::Concern

  private

  def pagination_params
    params.fetch(:page, {}).permit(:size, :number)
  end
end