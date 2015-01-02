module Admin

  class NotesController < ApplicationController

    before_action :authenticate_user!
    before_action :load_company, :set_job, :set_application

    # -------------------------------------------------------------------------------------------------------------------
    # POST :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:application_id/notes
    # -------------------------------------------------------------------------------------------------------------------
    def create
      @note = @application.notes.new(note_params)
      @note.user_id = current_user.id

      if @note.save
        redirect_to admin_job_application_url(@job, @application, subdomain: @company.subdomain), notice: 'Note was successfully created.'
      else
        render :new
      end
    end

    # -------------------------------------------------------------------------------------------------------------------
    # DELETE :subdomain.pinpoint.hr/admin/jobs/:job_id/applications/:application_id/notes/:id
    # -------------------------------------------------------------------------------------------------------------------
    def destroy
      @note.destroy
      redirect_to admin_job_application_url(@job, @application, subdomain: @company.subdomain), notice: 'Note was successfully destroyed.'
    end

    # -------------------------------------------------------------------------------------------------------------------
    # Private
    # -------------------------------------------------------------------------------------------------------------------
    private

    # Use callbacks to share common setup or constraints between actions.
    def set_job
      @job = @company.jobs.find(params[:job_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = @job.applications.find(params[:application_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:content)
    end

  end

end