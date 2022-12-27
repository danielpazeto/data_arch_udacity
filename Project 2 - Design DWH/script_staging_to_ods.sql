USE DATABASE UDACITY_DA_ND_PROJECT2;

--Business table creation and contraints
DROP TABLE IF EXISTS ODS.BUSINESS;
CREATE TABLE ODS.BUSINESS AS 
SELECT 
    json_data:business_id::string as business_id,
    json_data:name::string as name,
    json_data:address::string as address,
    json_data:city::string as city,
    json_data:state::string as state,
    json_data:postal_code::string as postal_code,
    json_data:review_count::number as review_count,
    json_data:latitude::double as latitude,
    json_data:longitude::double as longitude,
    json_data:hours.Sunday::string as sunday_hours,
    json_data:hours.Monday::string as monday_hours,
    json_data:hours.Tuesday::string as tuesday_hours,
    json_data:hours.Wednesday::string as wednesday_hours,
    json_data:hours.Thursday::string as thursday_hours,
    json_data:hours.Friday::string as friday_hours,
    json_data:hours.Saturday::string as saturday_hours,
    json_data:categories::string as categories,
    json_data:is_open = 1::boolean as is_open,
    json_data:stars::number as stars
FROM STAGING.BUSINESS;
ALTER TABLE ODS.BUSINESS ADD CONSTRAINT pk_business PRIMARY KEY (business_id);

--User table creation and contraints
DROP TABLE IF EXISTS ODS.USER;
CREATE TABLE ODS.USER AS
SELECT
    json_data:average_stars as average_stars,
    json_data:compliment_cool as compliment_cool,
    json_data:compliment_cute as compliment_cute,
    json_data:compliment_funny as compliment_funny,
    json_data:compliment_hot as compliment_hot,
    json_data:compliment_list as compliment_list,
    json_data:compliment_more as compliment_more,
    json_data:compliment_note as compliment_note,
    json_data:compliment_photos as compliment_photos,
    json_data:compliment_plain as compliment_plain,
    json_data:compliment_profile as compliment_profile,
    json_data:compliment_writer as compliment_writer,
    json_data:cool as cool,
    json_data:elite as elite, 
    json_data:fans as fans,
    json_data:friends as  friends, 
    json_data:funny as funny,
    json_data:name as name, 
    json_data:review_count as  review_count, 
    json_data:useful as useful,
    json_data:user_id::string as user_id,
    json_data:yelping_since as yelping_since
FROM STAGING.USER;
ALTER TABLE ODS.USER ADD CONSTRAINT pk_user PRIMARY KEY (user_id);


--Checkin table creation and contraints
DROP TABLE IF EXISTS ODS.CHECKIN;
CREATE TABLE ODS.CHECKIN AS
SELECT
    json_data:business_id::string as business_id,
    dt.value::datetime as checkin_datetime
FROM STAGING.CHECKIN, lateral flatten(split(json_data:date, ',')) dt;

ALTER TABLE ODS.CHECKIN ADD CONSTRAINT fk_business_id FOREIGN KEY (business_id) REFERENCES ODS.BUSINESS (business_id);

--Covid features table creation and contraints
DROP TABLE IF EXISTS ODS.COVID_FEATURES;
CREATE TABLE ODS.COVID_FEATURES AS
SELECT
    json_data:business_id::string as business_id,
    json_data:"Call To Action enabled"::boolean as call_to_action_enabled,
    json_data:"Covid Banner"::string as covid_banner,
    json_data:"Grubhub enabled"::boolean as grudhub_enabled,
    json_data:"Request a Quote Enabled"::boolean as request_a_quote_enabled,
    json_data:"Temporary Closed Until"::string as temporary_cloed_until,
    json_data:"Virtual Services Offered"::string as vistural_services_offered,
    json_data:"delivery or takeout"::boolean as delivery_or_takeout,
    json_data:"highlights"::string as highlights
FROM STAGING.COVID_FEATURES;
ALTER TABLE ODS.COVID_FEATURES ADD CONSTRAINT fk_business_id FOREIGN KEY (business_id) REFERENCES ODS.BUSINESS (business_id);


--Precipitation table creation and contraints
DROP TABLE IF EXISTS ODS.PRECIPITATION;
CREATE TABLE ODS.PRECIPITATION AS
SELECT
    TO_DATE(date,'YYYYMMDD' ) as date,
    TRY_CAST(precipitation AS FLOAT)::float as precipitation,
    precipitation_normal::float as precipitation_normal
FROM STAGING.PRECIPITATION;
ALTER TABLE ODS.PRECIPITATION ADD CONSTRAINT pk_date PRIMARY KEY (date);


--Temparature table creation and contraints
DROP TABLE IF EXISTS ODS.TEMPERATURE;
CREATE TABLE ODS.TEMPERATURE AS
SELECT
    TO_DATE(date,'YYYYMMDD' ) as date,
    min::integer as min,
    max::integer as max,
    normal_min::float as normal_min,
    normal_max::float as normal_max
FROM STAGING.TEMPERATURE;
ALTER TABLE ODS.TEMPERATURE ADD CONSTRAINT pk_date PRIMARY KEY (date);


--Review table creation and contraints
DROP TABLE IF EXISTS ODS.REVIEW;
CREATE TABLE ODS.REVIEW AS
SELECT
    json_data:review_id::string as review_id,
    json_data:business_id::string as business_id,
    json_data:user_id::string as user_id,
    json_data:date::date as date,
    json_data:cool=1 as is_cool,
    json_data:funny=1 as is_funny,
    json_data:useful=1 as is_useful,
    json_data:stars::integer as stars,
    json_data:text::string as text
FROM STAGING.REVIEW;
ALTER TABLE ODS.REVIEW ADD CONSTRAINT pk_review PRIMARY KEY (review_id);
ALTER TABLE ODS.REVIEW ADD CONSTRAINT fk_business FOREIGN KEY (business_id) REFERENCES ODS.BUSINESS (business_id);
ALTER TABLE ODS.REVIEW ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES ODS.USER (user_id);


--Tip table creation and contraints
DROP TABLE IF EXISTS ODS.TIP;
CREATE TABLE ODS.TIP AS
SELECT
    json_data:business_id::string as business_id,
    json_data:user_id::string as user_id,
    json_data:date::date as date,
    json_data:compliment_count as compliment_count,
    json_data:text::string as text
FROM STAGING.TIP;
ALTER TABLE ODS.TIP ADD CONSTRAINT fk_business FOREIGN KEY (business_id) REFERENCES ODS.BUSINESS (business_id);
ALTER TABLE ODS.TIP ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES ODS.USER (user_id);
