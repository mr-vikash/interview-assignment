class EbookService
  def create(params)
    ebook = Ebook.new(
      title: params[:title],
      author: params[:author]
    )

    ebook.file.attach(params[:file]) if params[:file].present?

    ebook.save

    ebook
  end

  def search(query)
    return Ebook.order(created_at: :desc) if query.blank?

    Ebook
      .joins("LEFT JOIN active_storage_attachments ON active_storage_attachments.record_id = ebooks.id")
      .joins("LEFT JOIN active_storage_blobs ON active_storage_blobs.id = active_storage_attachments.blob_id")
      .where(
        "ebooks.title LIKE :query
        OR ebooks.author LIKE :query
        OR active_storage_blobs.filename LIKE :query",
        query: "%#{query}%"
      )
      .distinct
  end

   def find(id)
    Ebook.find(id)
  end

  def destroy(id)
    ebook = Ebook.find(id)
    ebook.destroy

    ebook
  end
end