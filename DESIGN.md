# Design Document

By Max Morris
Video overview: [Watch Here](https://youtu.be/CGp5sz73bXI)

## Scope

The database for Airline Pricing Strategy Analysis includes all entities necessary to facilitate the process of tracking airline ticket prices, competitor pricing, and the impact of marketing campaigns on bookings. As such, included in the database's scope is:

* Flights, including airline, departure, arrival, and duration details.
* Ticket Prices, including prices by seat class for each flight at different times
* Competitor Pricing, including competitor airlines' ticket prices for similar routes.
* Marketing Campaigns, including promotions, discounts, and seasonal offers.
* Bookings, including the number of tickets sold per fare class and per campaign.
* Out of scope are elements like airline operational costs, real-time price adjustments, and passenger-specific details.

## Functional Requirements

This database will support:

* CRUD operations for flights, ticket prices, competitor pricing, marketing campaigns, and bookings.
* Tracking price fluctuations for airline tickets over time.
* Analyzing how marketing campaigns (discounts, promotions) affect ticket sales.
* Comparing competitor pricing to assess market positioning.
* Identifying demand trends based on booking data and seasonality.

## Representation

Entities are captured in SQLite tables with the following schema.

### Entities

The database includes the following entities:

#### Flights

The flights table includes:

* id, which specifies the unique ID for the flight as an INTEGER. This column thus has the PRIMARY KEY constraint applied.
* airline, which specifies the airline operating the flight as TEXT.
* route, which specifies the flight route (e.g., LHR-JFK) as TEXT.
* departure_time, which specifies the scheduled departure time as NUMERIC.
* arrival_time, which specifies the scheduled arrival time as NUMERIC.

#### Ticket Prices

The ticket_prices table includes:

* id, which specifies the unique ID for the price entry as an INTEGER. This column thus has the PRIMARY KEY constraint applied.
* flight_id, which specifies the ID of the associated flight as an INTEGER. This column has the FOREIGN KEY constraint applied, referencing the id column in the flights table to ensure data integrity.
* class, which specifies the seat class (e.g., economy, business) as TEXT.
* price, which specifies the ticket price in USD as a NUMERIC.
* date_recorded, which specifies when the price was logged as a NUMERIC.

#### Competitor Pricing

The competitor_pricing table includes:

* id, which specifies the unique ID for the competitor price entry as an INTEGER. This column thus has the PRIMARY KEY constraint applied.
* flight_id, which specifies the ID of the associated flight as an INTEGER. This column has the FOREIGN KEY constraint applied, referencing the id column in the flights table to ensure data integrity.
* competitor_airline, which specifies the name of the competitor airline as TEXT.
* price, which specifies the competitor’s ticket price in USD as a NUMERIC.
* date_recorded, which specifies when the price was logged as a NUMERIC.

#### Marketing Campaigns

The marketing_campaigns table includes:

* id, which specifies the unique ID for the campaign as an INTEGER. This column thus has the PRIMARY KEY constraint applied.
* campaign_name, which specifies the name of the campaign as TEXT.
* discount_percentage, which specifies the discount offered as a NUMERIC.
* start_date, which specifies the campaign start date as NUMERIC.
* end_date, which specifies the campaign end date as NUMERIC.
* flight_id, which specifies the associated flight’s ID as an INTEGER, linking marketing campaigns to specific flights (used in the query SELECT * FROM "marketing_campaigns" WHERE "id" IN (SELECT "flight_id" FROM "flights" WHERE "route" = 'LHR-JFK');).

#### Bookings
The bookings table includes:

* id, which specifies the unique ID for the booking record as an INTEGER. This column thus has the PRIMARY KEY constraint applied.
* flight_id, which specifies the ID of the associated flight as an INTEGER. This column has the FOREIGN KEY constraint applied, referencing the id column in the flights table to ensure data integrity.
* class, which specifies the seat class as TEXT.
* tickets_sold, which specifies the number of tickets booked as an INTEGER.
* booking_date, which specifies the date of booking as a NUMERIC.

### Relationships

The below entity relationship diagram describes the relationships among the entities in the database.

![ER Diagram](diagram.svg)

As detailed by the diagram:

* One flight has multiple ticket price entries recorded over time.
* One flight has multiple competitor pricing records for comparison.
* One marketing campaign can be linked to multiple flights.
* One flight has multiple bookings, categorized by seat class.

## Optimizations

Per the typical queries in queries.sql, it is common for users of the database to:

Access all flights within a certain route. For that reason, indexes are created on the route and airline columns in the flights table.

Analyze pricing trends over time. Indexes are created on the date_recorded column in both the ticket_prices and competitor_pricing tables to speed retrieval.

Assess the impact of marketing campaigns on sales. Indexes are created on the campaign_name column in the marketing_campaigns table.

## Limitations

The current schema assumes historical data tracking and does not support real-time price adjustments. Expanding this functionality would require an external API to track price changes dynamically.

This database does not store individual passenger details for privacy reasons. If future versions require deeper customer segmentation, an anonymized customer database could be integrated.

The system does not track operational costs such as fuel prices, staff wages, or aircraft maintenance. If cost-based pricing analysis were required, additional financial tables would be necessary.
