class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders


  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_presence_of :image, :allow_blank => true
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than: 0

  def self.top_five
      joins(:item_orders)
      .select('items.id', 'sum(item_orders.quantity) AS total', 'items.name')
      .group('items.id')
      .order('total desc')
      .limit(5)
  end

  def self.bottom_five
      joins(:item_orders)
      .select('items.id', 'sum(item_orders.quantity) AS total', 'items.name')
      .group('items.id')
      .order('total asc')
      .limit(5)
  end

  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def quantity_sold
    item_orders.sum(:quantity)
  end

end
