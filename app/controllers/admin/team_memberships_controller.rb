class Admin::TeamMembershipsController < ApplicationController

  add_breadcrumb 'Teams', :admin_teams_path

  def index
    @team = Team.includes(:users).find( params[:team_id] )
    @users = User.includes( :teams ).order(:name).page(params[:page]).per(10)
    @users = add_search @users

    add_breadcrumb @team.name, admin_team_path( @team )
    add_breadcrumb 'Members', admin_team_users_path( @team )

    authorize! :read, User
  end

  def update
    transaction do
      @team = Team.find params[:team_id]
      @user = User.find params[:id]

      authorize! :read, @team
      authorize! :assign, @user

      current_teams = @user.teams.clone

      if ! @user.teams.blank? && ( @user.teams - [@team]).count >= 1
        if !params[:confirmation].blank? && [:add, :move].include?(params[:confirmation].to_sym)
          if params[:confirmation].to_sym == :add
            @user.teams << @team unless @user.member_of? @team
          else
            @user.teams = [@team]
          end
        else
          render :confirm_team
        end
      else
        @team.users << @user
      end
      @user.reload
      SendTeamChangedEmailJob.perform_async @user, current_user
      render 'update_membership' unless performed?
    end
  end

  def destroy
    @team = Team.find params[:team_id]
    @user = User.find params[:id]

    authorize! :read, @team
    authorize! :assign, @user

    @team.users.delete( @user )
    @user.reload
    render 'update_membership'
  end

  private

  def add_search users
    if ! params[:search].blank?
      @search_term = params[:search]
      term = "%#{@search_term}%"
      users = @users.where( 'name like ?', term )
    end
    users
  end
end
