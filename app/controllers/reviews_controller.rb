class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :set_restaurant
  before_action :authenticate_user!
  before_action :check_user, only: [:edit, :update, :destroy]

  respond_to :html

  def new
    @review = Review.new
    # respond_with(@review)
  end

  def edit
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.restaurant_id = @restaurant.id

  respond_to do |format|
    if @review.save
      format.html { redirect_to @restaurant, notice: 'Review was successfully created' }
      format.json { render :show, status: :created, location: @review }
    else
      format.html { render :new }
      format.json { render json: @review.errors, status: :unprocessable_entity}
    end
    end
    end

    # @review.save
    # respond_with(@review)


  def update
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to restaurant_path(@restaurant), notice: 'Review was successfully updated' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit }
        format.json { render json: @review.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to restaurant_path(@restaurant), notice: 'Review was successfully destroyed' }
      format.json { head :no_content}
    end
  end

  private
    def set_review
      @review = Review.find(params[:id])
    end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def check_user
    unless (@review.user == current_user) || (current_user.admin?)
      redirect_to root_url, alert: "Sorry, This review belongs to someone else"
    end
  end

    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
