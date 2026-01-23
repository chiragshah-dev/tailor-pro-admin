class TemporaryFile < ApplicationRecord
  include Auditable

  has_many_attached :files

  after_commit :store_primary_file_url, on: :create

  def all_file_urls
    files.map { |file| raw_s3_url(file.blob) }
  end

  private

  def raw_s3_url(blob)
    blob.service.url(
      blob.key,
      expires_in: 24.hour,
      filename: ActiveStorage::Filename.new(blob.filename.to_s),
      disposition: "inline",
      content_type: blob.content_type,
    )
  end

  def store_primary_file_url
    return unless files.attached?

    blob = files.first.blob

    update_columns(
      image_url: raw_s3_url(blob),
      file_type: blob.content_type.split("/").first,
    )
  end
end
