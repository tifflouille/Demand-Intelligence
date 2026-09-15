| Table       | Column                          | Meaning                                         | Key / Join role        | Relevant? |
| ----------- | ------------------------------- | ----------------------------------------------- | ---------------------- | --------- |
| Orders      | `order_id`                      | Unique identifier for an order                  | **Primary key**        | Yes       |
| Orders      | `customer_id`                   | Unique identifier for the customer              | Customer identifier    | No        |
| Orders      | `order_status`                  | Current/final status of the order               | —                      | Maybe     |
| Orders      | `order_purchase_timestamp`      | Date and time when the order was placed         | —                      | **Yes**   |
| Orders      | `order_approved_at`             | Date/time when payment was approved             | —                      | No        |
| Orders      | `order_delivered_carrier_date`  | Date/time order was handed to the carrier       | —                      | No        |
| Orders      | `order_delivered_customer_date` | Date/time order was delivered to customer       | —                      | No        |
| Orders      | `order_estimated_delivery_date` | Estimated delivery date                         | —                      | No        |
| Order Items | `order_id`                      | Identifier linking the item to an order         | **Join → Orders**      | Yes       |
| Order Items | `order_item_id`                 | Sequential item/line identifier within an order | Part of composite identifier | Yes       |
| Order Items | `product_id`                    | Identifier of the product purchased             | **Join → Products**    | **Yes**   |
| Order Items | `seller_id`                     | Identifier of the seller                        | Seller identifier      | No        |
| Order Items | `shipping_limit_date`           | Seller's shipping deadline                      | —                      | No        |
| Order Items | `price`                         | Price of the product item                       | —                      | **Yes**   |
| Order Items | `freight_value`                 | Freight/shipping cost associated with the item  | —                      | No        |
| Products    | `product_id`                    | Unique identifier of a product                  | **Primary key / Join** | **Yes**   |
| Products    | `product_category_name`         | Product category                                | —                      | **Yes**   |

