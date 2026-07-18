module Api
  module V1
    class EbooksController < BaseController

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

      private

      def ebook_params
        params.permit(:title, :author, :file)
      end
    end
  end
end