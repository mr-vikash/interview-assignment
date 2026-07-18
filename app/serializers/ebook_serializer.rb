class EbookSerializer
  include Rails.application.routes.url_helpers

  def initialize(ebook)
    @ebook = ebook
  end

  def as_json
    {
      id: @ebook.id,
      title: @ebook.title,
      author: @ebook.author,
      file_name: @ebook.file.filename.to_s,
      file_size: @ebook.file.byte_size,
      file_type: @ebook.file.content_type,
      uploaded_at: @ebook.created_at,
      file_url: file_url
    }
  end

  private

  def file_url
    return nil unless @ebook.file.attached?

    rails_blob_url(@ebook.file, only_path: false)
  end
end