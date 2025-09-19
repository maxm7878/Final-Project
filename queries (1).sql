-- Retrieve all flights stored in the database
SELECT * FROM flights;

-- Find the ticket price history for a specific flight
SELECT * FROM ticket_prices WHERE flight_id = 1;

-- Compare an airline's ticket prices with a competitor pricing for the same flight route
SELECT flights.airline, flights.route, ticket_prices.price AS our_price,
       competitor_pricing.competitor_airline, competitor_pricing.price AS competitor_price
FROM flights
JOIN ticket_prices ON flights.id = ticket_prices.flight_id
JOIN competitor_pricing ON flights.id = competitor_pricing.flight_id
WHERE flights.route = 'LHR-JFK';

-- Check which flights had promotional discounts applied and how they performed
SELECT flights.airline, flights.route, marketing_campaigns.campaign_name, marketing_campaigns.discount_percentage
FROM flights
JOIN marketing_campaigns ON flights.id = marketing_campaigns.flight_id;

-- Check which flights had the highest number of ticket bookings
SELECT flights.airline, flights.route, SUM(bookings.tickets_sold) AS total_tickets
FROM flights
JOIN bookings ON flights.id = bookings.flight_id
GROUP BY flights.id
ORDER BY total_tickets DESC;


-- Find all flights operated by a specific airline
SELECT * FROM "flights" WHERE "airline" = 'British Airways';

-- Find all ticket prices for a specific flight route
SELECT * FROM "ticket_prices" WHERE "flight_id" IN ( SELECT "id" FROM "flights" WHERE "route" = 'LHR-JFK' );

-- Find all ticket prices for a specific seat class
SELECT * FROM "ticket_prices" WHERE "class" = 'Economy';

-- Find all competitor prices for a specific flight
SELECT * FROM "competitor_pricing" WHERE "flight_id" = ( SELECT "id" FROM "flights" WHERE "route" = 'LHR-JFK' );

-- Find the lowest recorded price for a specific flight
SELECT MIN("price") AS lowest_price FROM "ticket_prices" WHERE "flight_id" = ( SELECT "id" FROM "flights" WHERE "route" = 'LHR-JFK' );

-- Find all marketing campaigns that impacted a specific flight
-- Corrected query: Assuming marketing_campaigns should be linked to flights via a flight_id
SELECT * FROM "marketing_campaigns" WHERE "id" IN ( SELECT "flight_id" FROM "flights" WHERE "route" = 'LHR-JFK' );

-- Find total tickets sold for a specific flight and seat class
SELECT SUM("tickets_sold") AS total_tickets FROM "bookings" WHERE "flight_id" = ( SELECT "id" FROM "flights" WHERE "route" = 'LHR-JFK' ) AND "class" = 'Business';

-- Insert a new flight record
INSERT INTO "flights" ("airline", "route", "departure_time", "arrival_time") VALUES ('Emirates', 'DXB-JFK', '2025-06-10 14:00:00', '2025-06-10 22:00:00');

-- Insert a new ticket price for an existing flight
INSERT INTO "ticket_prices" ("flight_id", "class", "price", "date_recorded") VALUES (1, 'Economy', 450.00, '2025-02-25');

-- Insert a new competitor price for an existing flight
INSERT INTO "competitor_pricing" ("flight_id", "competitor_airline", "price", "date_recorded") VALUES (1, 'American Airlines', 470.00, '2025-02-25');

-- Insert a new marketing campaign
INSERT INTO "marketing_campaigns" ("campaign_name", "discount_percentage", "start_date", "end_date") VALUES ('Winter Sale', 15, '2025-12-01', '2025-12-15');

-- Insert a new booking record
INSERT INTO "bookings" ("flight_id", "class", "tickets_sold", "booking_date") VALUES (1, 'Business', 30, '2025-02-24');
