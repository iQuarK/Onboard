class Attachment < ActiveRecord::Base

  # -------------------------------------------------------------------------------------------------------------------
  # Attributes
  # -------------------------------------------------------------------------------------------------------------------
  mount_uploader :attachment, AttachmentUploader

  # -------------------------------------------------------------------------------------------------------------------
  # Nested Attributes
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Validations
  # -------------------------------------------------------------------------------------------------------------------
  validates_presence_of :attachment

  # -------------------------------------------------------------------------------------------------------------------
  # Associations
  # -------------------------------------------------------------------------------------------------------------------
  belongs_to :attachable, polymorphic: true


  # -------------------------------------------------------------------------------------------------------------------
  # Constants
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Named Scopes
  # -------------------------------------------------------------------------------------------------------------------


  # -------------------------------------------------------------------------------------------------------------------
  # Callbacks
  # -------------------------------------------------------------------------------------------------------------------



  # -------------------------------------------------------------------------------------------------------------------
  # Public Methods
  # -------------------------------------------------------------------------------------------------------------------


  # -------------------------------------------------------------------------------------------------------------------
  # Private Methods
  # -------------------------------------------------------------------------------------------------------------------
  private



end