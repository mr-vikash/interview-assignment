module Api
  module V1
    class EbooksController < BaseController
      before_action :set_ebook, only: [:show, :download, :destroy]

      def index
        ebooks = Ebook.order(created_at: :desc)

        render json: ebooks.map { |ebook| EbookSerializer.new(ebook).as_json }
      end

      def create
        ebook = EbookService.new.create(ebook_params)

        if ebook.persisted?
          render json: {
            success: true,
            message: "Ebook uploaded successfully",
            data: EbookSerializer.new(ebook).as_json
          }, status: :created
        else
          render json: {
            success: false,
            errors: ebook.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

      def search
        ebooks = EbookService.new.search(params[:q])

        render json: {
          success: true,
          data: ebooks.map { |ebook| EbookSerializer.new(ebook).as_json }
        }
      end

      def download
        if @ebook.file.attached?
          redirect_to rails_blob_url(@ebook.file, disposition: "attachment")
        else
          render json: {
            success: false,
            message: "File not found"
          }, status: :not_found
        end
      end

      def destroy
        @ebook.destroy

        render json: {
          success: true,
          message: "#{@ebook.title} deleted successfully."
        }
      end

      private

      def ebook_params
        params.permit(:title, :author, :file)
      end

      def set_ebook
         @ebook = EbookService.new.find(params[:id])
      end
    end
  end
end