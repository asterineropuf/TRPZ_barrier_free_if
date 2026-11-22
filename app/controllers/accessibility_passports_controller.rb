class AccessibilityPassportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_place
  before_action :authorize_place_owner!
  before_action :set_passport, only: %i[edit update destroy]

  def new
    if @place.accessibility_passport.present?
      redirect_to edit_place_accessibility_passport_path(@place)
    else
      @passport = @place.build_accessibility_passport
    end
  end

  def create
    @passport = @place.build_accessibility_passport(passport_params)

    if @passport.save
      redirect_to @place, notice: "Паспорт безбар'єрності для «#{@place.name}» створено."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @passport.update(passport_params)
      redirect_to @place, notice: "Паспорт безбар'єрності оновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @passport.destroy!
    redirect_to @place, status: :see_other, notice: "Паспорт безбар'єрності видалено."
  end

  private

  def set_place
    @place = Place.find(params[:place_id])
  end

  def authorize_place_owner!
    if @place.user.present? && @place.user != current_user
      redirect_to @place, alert: "Недостатньо прав для зміни паспорта цієї локації."
    end
  end

  def set_passport
    @passport = @place.accessibility_passport
    redirect_to new_place_accessibility_passport_path(@place), alert: "Паспорт ще не створено." unless @passport
  end

  def passport_params
    params.require(:accessibility_passport).permit(
      :ramp_angle, :door_width_cm, :has_elevator, :hazard_gutters_note
    )
  end
end