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
      file_size: readable_size,
      file_type: @ebook.file.content_type,
      uploaded_at: @ebook.created_at.strftime("%d %b %Y"),
      download_url: download_url
    }
  end

  private

  def download_url
    "/api/v1/ebooks/#{@ebook.id}/download"
  end

  def readable_size
    ActiveSupport::NumberHelper.number_to_human_size(@ebook.file.byte_size)
  end
end