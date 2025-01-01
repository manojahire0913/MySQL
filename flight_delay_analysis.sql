						-- FLIGHT DELAY ANLYSIS --
use `flight_delay_anlysis`;

-- 1) Weekday Vs Weekend total flights statistics
-- weekday vs weekend total flights
select
case
when DAY_OF_WEEK <6 then "weekday"
else "weekend"
end as weeks, count(FLIGHT_NUMBER) as Total_flights
from flights
group by weeks;
-----------------------------------------------------------------------------------------------------------------------------------
-- 2) Total number of cancelled flights for JetBlue Airways on first date of every month
select MONTH, count(F.CANCELLED) as CANCELLED_FLIGHTS
FROM flights AS F
JOIN airlines as A
on F.AIRLINE = A.IATA_CODE
where A.AIRLINE = "jetBlue Airways" and F.CANCELLED = 1 and F.DAY = 1
group by MONTH;

-- 3) Week wise, State wise and City wise statistics of delay of flights with airline details

-- WEEK WISE TOTAL FLIGHT DELAYED
WITH CTE AS 
(select CASE
WHEN f.DAY_OF_WEEK<6 then "weekday"
else "weekend"
END AS WEEKS,
a.AIRLINE , f.DEPARTURE_DELAY
from flights as f
join airlines as a
on f.AIRLINE = a.IATA_CODE
where DEPARTURE_DELAY > 15
)
select WEEKS,AIRLINE,count(DEPARTURE_DELAY) AS FLIGHTS_DELAY
from CTE
group by WEEKS , AIRLINE
order by FLIGHTS_DELAY desc;

-- state wise total flight delayed
 WITH cte AS (
SELECT p.state, a.airline, f.departure_delay
FROM airports AS p
JOIN flights AS f ON p.IATA_CODE = f.ORIGIN_AIRPORT
JOIN airlines AS a ON f.AIRLINE = a.IATA_CODE
WHERE f.departure_delay > 15
)
select state, airline, COUNT(departure_delay) AS delay_count
FROM cte
GROUP BY state, airline
order by delay_count desc;

-- city wise total flight delayed
WITH CTE AS (
select P.CITY, A.AIRLINE, F.DEPARTURE_DELAY
FROM airports AS P
JOIN flights AS F
ON P.IATA_CODE = F.ORIGIN_AIRPORT
JOIN airlines AS A
ON F.AIRLINE = A.IATA_CODE
)
SELECT CITY, AIRLINE, COUNT(DEPARTURE_DELAY) as DEPARTURE_DELAY
FROM CTE
WHERE DEPARTURE_DELAY >15
group by city, airline
order by departure_delay desc;

-- 4) Number of airlines with No departure/arrival delay with distance covered between 2500 and 3000
SELECT a.airline, COUNT(f.AIRLINE) AS Nodeparture_arrivaldelay
FROM flights f
JOIN airlines a ON f.AIRLINE = a.IATA_CODE
WHERE f.departure_delay = 0
  AND f.arrival_delay = 0
  AND f.distance BETWEEN 2500 AND 3000
GROUP BY airline
ORDER BY Nodeparture_arrivaldelay DESC;

  
 




