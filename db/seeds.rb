# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

ItemOrder.destroy_all
Order.destroy_all
User.destroy_all
Merchant.destroy_all
Item.destroy_all

#merchants
pokemon_shop = Merchant.create(name: "Brett's Pokemon Shop!", address: "5465 Fireball ln", city: "Alaska", state: "CO", zip: 90054)
barbie_shop = Merchant.create(name: "Brian's Barbie Shop", address: "9898 Pink Flower Ave", city: "Delaware", state: "FL", zip: 8432)
legos_shop = Merchant.create(name: "Eduardo's Lego Shop", address: "1232 Building Block ln", city: "LA", state: "CA", zip: 90210)
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
scuba_shop = Merchant.create(name: "Nick's Scuba Shop", address: '8976 Ocean Ave', city: 'San Diego', state: 'CA', zip: 91191)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
#pokemon item
picachu = pokemon_shop.items.create(name: "Picachu", description: "Cute and sweet", price: 500, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT4PewcMiE3DBPshmdW_t5oRULoBoyxNrTE7Q&usqp=CAU", inventory: 20)
charazard = pokemon_shop.items.create(name: "Charazard", description: "Very rude", price: 7, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSNpBmAK50aHhPZMCw1B3o-Xvgm9Ocd0yCOUg&usqp=CAU", inventory: 5)
#barbie items
barbie_1 = barbie_shop.items.create(name: "Falechia", description: "beautiful in pink", price: 300, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRdYkyQHS6trfq325x8kEocYhptd-3pxKpyCA&usqp=CAU", inventory:69)
barbie_2 = barbie_shop.items.create(name: "Dave", description: "Handy man", price: 5, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRPz5kbl4Qc6P2SOKLi0A63lRTrorW6vyidjA&usqp=CAU", inventory: 43)
#legos items
tower = legos_shop.items.create(name: "Castle", description: "epic and glorious", price: 22, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSKUZDbGra_dHzHxPzD-_8Sk3JjB6u9EpaXqQ&usqp=CAU", inventory: 4)
car = legos_shop.items.create(name: "Car", description: "fast and loud", price: 56, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRl2KCh6ytGsRsHImL1gkNeEr6d_nz8yBejmg&usqp=CAU", inventory: 100)
#scuba shop items
scuba_steve = scuba_shop.items.create(name: "Bathtub Buddy", description: "He can dive deep", price: 2000, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQpqzsLgDQ5egPZpF-M1aNcgkK9WZiB5CVv8w&usqp=CAU", inventory: 101)
goggles = scuba_shop.items.create(name: "Goggles", description: "Cheap and not worth the buy", price: 3, image: "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSl4pO86Z6zPk530M4bmZHxqmgPZcO-nc8qCw&usqp=CAU", inventory: 150)

user = User.create(name: "John Doe", address: "123 Main Street", city: "Anytown", state: "Anystate", zip: 123456, email: "funbucket13@gmail.com", password: "test", role: 0)
user = bike_shop.users.create(name: "John", address: "123 Main Street", city: "Anytown", state: "Anystate", zip: 123456, email: "merchant@merchant.com", password: "test", role: 1)
user = User.create(name: "John", address: "123 Main Street", city: "Anytown", state: "Anystate", zip: 123456, email: "admin@admin.com", password: "test", role: 2)

order_1 = user.orders.create!(
  name: 'Ogirdor',
  address: '1 2nd St.',
  city: 'Bloomington',
  state: 'IN',
  zip: '24125',
  status: 2
)
order_2 = user.orders.create!(
  name: 'Billy',
  address: '1 2nd St.',
  city: 'Bloomington',
  state: 'IN',
  zip: '24125',
  status: 2
)
order_3 = user.orders.create!(
  name: 'Sam',
  address: '1 2nd St.',
  city: 'Bloomington',
  state: 'IN',
  zip: '24125'
)
item_order = ItemOrder.create!(item: car, order: order_1, quantity: 1, price: (car.price * 1))
item_order = ItemOrder.create!(item: scuba_steve, order: order_2, quantity: 500, price: (scuba_steve.price * 500))
item_order = ItemOrder.create!(item: barbie_1, order: order_3, quantity: 200, price: (barbie_1.price * 200))

discount = pokemon_shop.discounts.create!(name: 'Fall Discount', min_quantity: 2, discount_percent: 50)
discount_1 = pokemon_shop.discounts.create!(name: 'Thanksgiving Discount', min_quantity: 3, discount_percent: 100)
