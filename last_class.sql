-- Preview
------date:2022.10.14
------dataset: Braxilian E-Commerce Public Dataset by Olist
------class:datarian last class

-- 1. orders 테이블 안의 데이터는 며칠 치 일까? 첫행+마지막행 확인!
SELECT *
FROM olist_orders_dataset
ORDER BY order_purchase_timestamp
LIMIT 1

SELECT *
FROM olist_orders_dataset
ORDER BY order_purchase_timestamp DESC
LIMIT 1
-- 강사님 풀이: SELECT MIN(order_purchase_timestamp), MAX(order_purchase_timestamp)


-- 2. Customer_city 컬럼의 데이터 종류 세기
SELECT customer_city, COUNT(customer_city) as city
FROM olist_customers_dataset
GROUP BY customer_city
ORDER BY city DESC
-- 고객 거주 주 이름까지는 찾지 못했으나, customer_id로 찾을 수 있을 것으로 보임. 고유 키값이 유일함.
-- 강사님 풀이: SELECT DISTINCT customer_state FROM olist_custoemrs_dataset
------------ SELECT * FROM olist_orders_dataset INNER JOIN olist_customer_dataset c ON o.custoemr_id = c.customer_id
-- + customers who never ordered 가 LEFT JOIN을 가장 잘 설명하는 예제이다!


-- 3. 결제 로그 데이터와 금액 데이터는 어디에?
---- olist_order_payments_dataset에 customer_id가 있다. 결제 금액이 함께 나타나있으므로 확인 가능하다.
-- 여기부터는 강사님 풀이만 ...!
SELECT order_id
      , COUNT(*) COUNT
FROM olist_order_payments_dataset
GROUP BY order_id
HAVING cnt >= 2

-- 4. 매출 top3를 찾자
SELECT *
FROM olist_order_payments_dataset o
     INNER JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
     INNER JOIN olist_order_customers_dataset c ON c.customer_id = p.order_id
WHERE o.order_purchase_timestamp BETWEEN '날짜' AND '날짜'
GROUP BY c.customer_state
ORDER BY revenue DESC
LIMIT 3

-- 5. 월별 매출금액을 찾자!!
-- 1. 날짜기간 내 데이터를 추출 - orders > order_purchase_timestamp
-- 2. 겹치는 키값을 통해 매출금액 계산 - payments > payment_value
SELECT MONTH(o.order_purchase_timestamp) m, ROUND(SUM(payment_value))
FROM olist_orders_dataset o
     INNER JOIN olist_order_payments_dataset p ON o.order_id = p.order_id
     WHERE o.order_purchase_timestamp BETWEEN '2017-05-01' AND '2017-11-19'
GROUP BY m
LIMIT 10

