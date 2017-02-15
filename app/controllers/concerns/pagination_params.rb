module PaginationParams
  extend ActiveSupport::Concern

  private

  def pagination_params
    params.require(:page).permit(:size, :number)
  end
end