class ReviewsController < ApplicationController
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :set_restaurant
  before_action :authenticate_user!

  # respond_to :html

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
      format.html { redirect_to root_path, notice: 'Review was successfully created' }
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
        format.html { redirect_to @review, notice: 'Review was successfully updated' }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :new }
        format.json { render json: @review.errors, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @review.destroy
    respond_with(@review)
  end

  private
    def set_review
      @review = Review.find(params[:id])
    end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
