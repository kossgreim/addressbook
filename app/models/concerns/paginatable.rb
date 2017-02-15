module Paginatable
  extend ActiveSupport::Concern

  module ClassMethods
    # adds pagination
    def paginate(params)
      page(params[:number] || 1).per(params[:size] || 25)
    end
  end
end