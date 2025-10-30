class Media < ApplicationRecord
  # Associations
  belongs_to :folder
  has_one_attached :file
  has_one_attached :thumbnail

  # Validations
  validates :file, presence: true

  after_commit :generate_video_thumbnail, on: [:create, :update], if: :video?

  private

  def video?
    file.attached? && file.content_type&.start_with?("video")
  end

  def generate_video_thumbnail
    return if thumbnail.attached?  # prevent multiple runs
    return unless video?

    require "streamio-ffmpeg"

    video_path = ActiveStorage::Blob.service.send(:path_for, file.key)
    movie = FFMPEG::Movie.new(video_path)

    tmp_thumbnail = Tempfile.new(["thumbnail", ".jpg"], binmode: true)
    movie.screenshot(tmp_thumbnail.path, seek_time: 1, resolution: "320x240")

    thumbnail.attach(
      io: File.open(tmp_thumbnail.path),
      filename: "thumbnail.jpg",
      content_type: "image/jpeg",
    )

    tmp_thumbnail.close
    tmp_thumbnail.unlink
  rescue => e
    Rails.logger.error("Failed to generate thumbnail: #{e.message}")
  end
end
