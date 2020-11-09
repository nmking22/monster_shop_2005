# <div align="center">  Monster Shop 2008


![Name of image]( https://i.pinimg.com/originals/09/77/bc/0977bc66ef40ff2040e4c5026567e60f.jpg)



 ## Project Partners


[Brett Sherman](https://github.com/BJSherman80)<br>
[Eduardo Parra](https://github.com/helloeduardo) <br>
[Brian Liu](https://github.com/badgerbreezy) <br>
[Nick King](https://github.com/nmking22) <br>




## Description
"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will be able to get "shipped" by an admin. Each user role will have access to some or all CRUD functionality for application models.

## Final Extenion done solo by yours truley:
FINAL EXAM 
Bulk Discount
General Goals
Merchants add bulk discount rates for all of their inventory. These apply automatically in the shopping cart, and adjust the order_items price upon checkout.

Completion Criteria
Merchant Employees need full CRUD functionality on bulk discounts, and will be accessed a link on the merchant's dashboard.
You will implement a percentage based discount:
5% discount on 20 or more items
A merchant can have multiple bulk discounts in the system.
When a user adds enough quantity of a single item to their cart, the bulk discount will automatically show up on the cart page.
A bulk discount from one merchant will only affect items from that merchant in the cart.
A bulk discount will only apply to items which exceed the minimum quantity specified in the bulk discount. (eg, a 5% off 5 items or more does not activate if a user is buying 1 quantity of 5 different items; if they raise the quantity of one item to 5, then the bulk discount is only applied to that one item, not all of the others as well)
When there is a conflict between two discounts, the greater of the two will be applied.
Final discounted prices should appear on the orders show page.

Mod 2 Learning Goals reflected:
Database relationships and migrations
Advanced ActiveRecord
Software Testing



## Schema
![Schema](https://user-images.githubusercontent.com/68172332/98299243-9f0c8f80-1f74-11eb-9a67-e87dbf0354ff.png)



## Statistics
   ![](https://img.shields.io/badge/Rails-5.2.4-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)    ![](https://img.shields.io/badge/Code-HTML-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a) ![](https://img.shields.io/badge/Code-CSS-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a)


## Instructions
Our application is hosted on [Heroku-Moster-Shop](https://quiet-dawn-01895.herokuapp.com), where you'll be able to view its functionality to the fullest. 

For usage on your local machine follow the instructions listed below:
```
git clone https://github.com/nmking22/monster_shop_2008
cd monster_shop_2008
bundle install
rake db:{drop,create,migrate,seed}
rails server
```
