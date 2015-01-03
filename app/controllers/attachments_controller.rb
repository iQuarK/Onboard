class AttachmentsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :load_attachable, only: [:index, :create]
  before_filter :set_attachment, only: [:destroy]

  # -------------------------------------------------------------------------------------------------------------------
  # GET ?
  # -------------------------------------------------------------------------------------------------------------------
  def index
    @attachments = @attachable.attachments
    @attachment = Attachment.new
  end

  # -------------------------------------------------------------------------------------------------------------------
  # POST ?
  # -------------------------------------------------------------------------------------------------------------------
  def create
    @attachment = @attachable.attachments.create(attachment_params)
  end

  # -------------------------------------------------------------------------------------------------------------------
  # GET /attachments/:id
  # -------------------------------------------------------------------------------------------------------------------
  def destroy
    @attachment.destroy
  end

  # -------------------------------------------------------------------------------------------------------------------
  # Private
  # -------------------------------------------------------------------------------------------------------------------
  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def load_attachable
    resource, id = request.path.split('/')[1, 2]
    @attachable = resource.singularize.classify.constantize.find(id)
  end

    # alternative option:
  # def load_attachable
  #   klass = [ChangeRequest].detect { |a| params["#{a.name.underscore}_id"] } # Model name goes into array
  #   @attachable = klass.find(params["#{klass.name.underscore}_id"])
  # end

  # Never trust parameters from the scary internet, only allow the white list through.
  def attachment_params
    params.require(:attachment).permit(:attachment, :attachable_id, :attachable_type)
  end

end
