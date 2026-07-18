class Ebook < ApplicationRecord
  has_one_attached :file

  validates :title, presence: true
  validates :author, presence: true
  validates :file, presence: true

  validate :acceptable_file

  private

  def acceptable_file
    return unless file.attached?

    unless file.content_type == "application/pdf"
      errors.add(:file, "must be a PDF")
    end

    if file.byte_size > 20.megabytes
      errors.add(:file, "is too large (maximum is 20MB)")
    end
  end
end