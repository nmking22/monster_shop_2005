class Merchant::DiscountsController < Merchant::BaseController

  def new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.discounts.create(discount_params)
    if discount.save
      redirect_to '/merchant/discounts'
    else
      flash[:error] = discount.errors.full_messages.to_sentence
      render :new
    end
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def index
    user = User.find(current_user.id)
    merchant = user.merchant
    @discounts = merchant.discounts
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)
      if @discount.save
        redirect_to "/merchant/discounts"
     else
       flash[:error] = @discount.errors.full_messages.to_sentence
       render :edit
     end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to "/merchant/discounts"
  end

end

  private

  def discount_params
    params.permit(:name,:min_quantity, :discount_percent)
  end
