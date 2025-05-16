# == Schema Information
#
# Table name: resources
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Resource < ApplicationRecord
  has_many :chunks, dependent: :destroy

  has_one_attached :file

  after_create_commit :create_chunks

  validates :name, presence: true
  validates :file, presence: true

  private

    def file_content
      pathname = Pathname.new(file.attachment.filename.to_s)
      filename_without_extension = pathname.basename.sub_ext("").to_s
      file_extension = pathname.extname

      Tempfile.open([ filename_without_extension, file_extension ]) do |tempfile|
        tempfile.binmode
        tempfile.write(file.attachment.download)
        tempfile.rewind

        Rails.logger.info "TEMPFILE: #{tempfile.path}"

        text = Langchain::Loader.load(tempfile.path).value
        text = text.flatten.join(" ") if text.is_a?(Array)
        text.strip
      end
    end

    def create_chunks
      return unless file.attached?

      chunk_size = 1024
      chunk_overlap = (chunk_size / 20.0).ceil

      Langchain::Chunker::RecursiveText
        .new(file_content, chunk_size:, chunk_overlap:)
        .chunks
        .map(&:text).each { |chunk| chunks.create!(body: chunk) }
    end
end
