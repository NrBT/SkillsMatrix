class Admin::TeamSkillsController < ApplicationController

  add_breadcrumb 'Teams', :admin_teams_path

  def index
    @team = Team.includes( :skills ).find( params[:team_id] )
    @skills = Skill.includes( :users ).order(:name).page(params[:page]).per(10)
    @skills = add_search @skills

    authorize! :read, @team

    add_breadcrumb @team.name, admin_team_path( @team )
    add_breadcrumb 'Skills', admin_team_skills_path( @team )
  end

  def update
    @team = Team.find params[:team_id]
    authorize! :recommend, Skill
    authorize! :read, @team
    @skill = Skill.find params[:id]
    @team.skills << @skill
    @skill.reload
    render 'update_skill' unless performed?
  end

  def destroy
    @team = Team.find params[:team_id]
    authorize! :recommend, Skill
    authorize! :read, @team
    @skill = Skill.find params[:id]
    @skill.teams.delete( @team )
    @team.reload
    render 'update_skill'
  end

  private

  def add_search skills
    if ! params[:search].blank?
      @search_term = params[:search]
      term = "%#{@search_term}%"
      skills = skills.where( 'name like ? OR description like ? OR context like ?', term, term, term )
    end
    skills
  end

end
