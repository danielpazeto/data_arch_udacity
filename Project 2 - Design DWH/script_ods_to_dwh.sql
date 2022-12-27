USE DATABASE UDACITY_DA_ND_PROJECT2;

-- dim_business creation and constraints
DROP TABLE IF EXISTS DWH.dim_business;
CREATE TABLE DWH.dim_business AS
SELECT
    name,
    business_id,
    state,
    city
FROM ODS.BUSINESS;
ALTER TABLE DWH.dim_business ADD CONSTRAINT pk_business PRIMARY KEY (business_id);


-- dim_climate creation and constraints
DROP TABLE IF EXISTS DWH.dim_climate;
create table dwh.dim_climate as
select 
    t.date,
    t.min as temp_min,
    t.max as temp_max,
    p.precipitation,
    p.precipitation_normal
FROM ODS.temperature t
JOIN ODS.precipitation p on t.date=p.date;
ALTER TABLE DWH.dim_climate ADD CONSTRAINT pk_date PRIMARY KEY (date);


-- dim_user creation and constraints
DROP TABLE IF EXISTS DWH.dim_user;
create table DWH.dim_user as
SELECT
    user_id,
    name,
    average_stars
FROM ODS.user;
ALTER TABLE DWH.dim_user ADD CONSTRAINT pk_user PRIMARY KEY (user_id);


-- dim_review creation and constraints
DROP TABLE IF EXISTS DWH.DIM_REVIEW;
CREATE TABLE DWH.DIM_REVIEW AS 
SELECT
    review_id,
    date,
    is_useful,
    stars,
    text
FROM ODS.review r;
ALTER TABLE DWH.DIM_REVIEW ADD CONSTRAINT pk_review PRIMARY KEY (review_id);



-- fact_review creation and constraints
DROP TABLE IF EXISTS DWH.FACT_REVIEW;
CREATE TABLE DWH.FACT_REVIEW AS 
SELECT
    review_id,
    business_id,
    user_id
FROM ODS.review r;
ALTER TABLE DWH.FACT_REVIEW ADD CONSTRAINT fk_review FOREIGN KEY (review_id) REFERENCES DWH.dim_review (review_id);
ALTER TABLE DWH.FACT_REVIEW ADD CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES DWH.dim_user (user_id);
ALTER TABLE DWH.FACT_REVIEW ADD CONSTRAINT fk_business FOREIGN KEY (business_id) REFERENCES DWH.dim_business (business_id);