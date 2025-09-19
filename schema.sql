-- Represent flights in the database
CREATE TABLE IF NOT EXISTS "flights" (
    "id" INTEGER PRIMARY KEY,
    "airline" TEXT NOT NULL,
    "route" TEXT NOT NULL,
    "departure_time" NUMERIC NOT NULL,
    "arrival_time" NUMERIC NOT NULL
);

-- Represent ticket prices for flights
CREATE TABLE IF NOT EXISTS "ticket_prices" (
    "id" INTEGER PRIMARY KEY,
    "flight_id" INTEGER,
    "class" TEXT NOT NULL,
    "price" NUMERIC NOT NULL CHECK("price" > 0),
    "date_recorded" NUMERIC NOT NULL,
    FOREIGN KEY("flight_id") REFERENCES "flights"("id")
);

-- Represent competitor pricing for flights
CREATE TABLE IF NOT EXISTS "competitor_pricing" (
    "id" INTEGER PRIMARY KEY,
    "flight_id" INTEGER,
    "competitor_airline" TEXT NOT NULL,
    "price" NUMERIC NOT NULL CHECK("price" > 0),
    "date_recorded" NUMERIC NOT NULL,
    FOREIGN KEY("flight_id") REFERENCES "flights"("id")
);

-- Represent marketing campaigns affecting ticket sales
CREATE TABLE IF NOT EXISTS "marketing_campaigns" (
    "id" INTEGER PRIMARY KEY,
    "campaign_name" TEXT NOT NULL,
    "discount_percentage" NUMERIC NOT NULL CHECK("discount_percentage" BETWEEN 0 AND 100),
    "start_date" NUMERIC NOT NULL,
    "end_date" NUMERIC NOT NULL,
    "flight_id" INTEGER,  -- Added this field to link marketing campaigns to flights
    FOREIGN KEY("flight_id") REFERENCES "flights"("id")
);

-- Represent bookings for flights
CREATE TABLE IF NOT EXISTS "bookings" (
    "id" INTEGER PRIMARY KEY,
    "flight_id" INTEGER,
    "class" TEXT NOT NULL,
    "tickets_sold" INTEGER NOT NULL CHECK("tickets_sold" >= 0),
    "booking_date" NUMERIC NOT NULL,
    FOREIGN KEY("flight_id") REFERENCES "flights"("id")
);

-- Create indexes to speed up common searches
CREATE INDEX IF NOT EXISTS "flight_route_search" ON "flights" ("route");
CREATE INDEX IF NOT EXISTS "ticket_price_search" ON "ticket_prices" ("date_recorded");
CREATE INDEX IF NOT EXISTS"competitor_price_search" ON "competitor_pricing" ("date_recorded");
CREATE INDEX IF NOT EXISTS "campaign_search" ON "marketing_campaigns" ("campaign_name");
