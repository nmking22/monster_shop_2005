class Merchant::BulkDiscountsController < Merchant::BaseController
  def index
    @bulk_discounts = BulkDiscount.all
  end

  def new
  end

  def create
    @bulk_discount = BulkDiscount.new(discount_params)
    @bulk_discount.save
    redirect_to '/merchant/bulk_discounts'
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    @bulk_discount.update(discount_params)
    redirect_to '/merchant/bulk_discounts'
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy!
    redirect_to '/merchant/bulk_discounts'
  end

  private
  def discount_params
    params.permit(:description, :discount_percent, :minimum_quantity)
  end
end
