class AuditlogsController < ApplicationController
  before_action :authorize
  before_action :check_permissons

  def index
    # TODO: add daily grouping
    @auditlogs = Auditlog.where(
      user_id: params[:user_id],
      created_at: (Date.current.beginning_of_day..Date.current.end_of_day)
    )
  end
end
