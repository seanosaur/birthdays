class BirthdaysController < ApplicationController
  before_action :authenticate_user!
  before_action :set_birthday, only: [:show, :edit, :update, :destroy]

  # GET /birthdays
  def index
    user_id = User.find(current_user)
    @birthdays = user_id.birthdays
    @birthdays.each do |b|
      now = Time.now.utc.to_date
      @age = now.year - b.date.year - ((now.month > b.date.month || (now.month == b.date.month && now.day >= b.date.day)) ? 0 : 1)
    end
  end

  # GET /birthdays/1
  def show
  end

  # GET /birthdays/new
  def new
    @birthday = Birthday.new
  end

  # GET /birthdays/1/edit
  def edit
  end

  # POST /birthdays
  def create
    @birthday = Birthday.new(birthday_params)
    @birthday.user_id = current_user.id
    respond_to do |format|
      if @birthday.save
        format.html { redirect_to @birthday, notice: 'Birthday was successfully created.' }
        format.json { render :show, status: :created, location: @birthday }
      else
        format.html { render :new }
        format.json { render json: @birthday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /birthdays/1
  def update
    respond_to do |format|
      if @birthday.update(birthday_params)
        format.html { redirect_to @birthday, notice: 'Birthday was successfully updated.' }
        format.json { render :show, status: :ok, location: @birthday }
      else
        format.html { render :edit }
        format.json { render json: @birthday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /birthdays/1
  def destroy
    @birthday.destroy
    respond_to do |format|
      format.html { redirect_to birthdays_url, notice: 'Birthday was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_birthday
      @birthday = Birthday.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def birthday_params
      params.require(:birthday).permit(:name, :date)
    end
end
