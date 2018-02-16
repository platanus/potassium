module Api::Paged
  extend ActiveSupport::Concern

  def paged(collection)
    if params.has_key?(:page)
      page_number = params[:page][:number].to_i
      page_size = params[:page][:size].to_i
      total = collection.count
      results_to = page_number * page_size
      results_from = results_to - page_size
      results_to = total if results_to > total
      response.headers["Content-Range"] = "items #{results_from}-#{results_to}/#{total}"

      return paginable_colletion(collection).page(page_number).per(page_size)
    end

    collection
  end

  def paginable_colletion(collection)
    return Kaminari.paginate_array(collection) if collection.is_a?(Array)
    collection
  end
end
