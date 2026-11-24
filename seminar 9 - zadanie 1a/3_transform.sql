BEGIN;

CREATE SCHEMA IF NOT EXISTS gold;

CREATE TABLE IF NOT EXISTS gold.dim_date (
    date_id INT PRIMARY KEY,
    full_date DATE NOT NULL,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    quarter INT NOT NULL,
    day_of_week INT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_time (
    time_id INT PRIMARY KEY,
    full_time TIME NOT NULL,
    hour INT NOT NULL,
    minute INT NOT NULL,
    second INT NOT NULL
);

CREATE TABLE IF NOT EXISTS gold.dim_user (
    user_id INT PRIMARY KEY,
    age INT,
    age_group TEXT,
    gender TEXT,
    occupation TEXT,
    zip_code TEXT
);

CREATE TABLE IF NOT EXISTS gold.dim_movies (
    movie_id INT PRIMARY KEY,
    title TEXT,
    release_year INT,
    genres TEXT
);

CREATE TABLE IF NOT EXISTS gold.fact_rating (
    rating_id INT PRIMARY KEY,
    user_id INT REFERENCES gold.dim_user(user_id),
    movie_id INT REFERENCES gold.dim_movies(movie_id),
    date_id INT REFERENCES gold.dim_date(date_id),
    time_id INT REFERENCES gold.dim_time(time_id),
    rating INT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_fact_rating_user_id ON gold.fact_rating(user_id);
CREATE INDEX IF NOT EXISTS idx_fact_rating_movie_id ON gold.fact_rating(movie_id);
CREATE INDEX IF NOT EXISTS idx_fact_rating_date_id ON gold.fact_rating(date_id);
CREATE INDEX IF NOT EXISTS idx_fact_rating_time_id ON gold.fact_rating(time_id);

TRUNCATE gold.fact_rating, gold.dim_user, gold.dim_movies, gold.dim_date, gold.dim_time;

INSERT INTO gold.dim_date (date_id, full_date, year, month, day, quarter, day_of_week)
SELECT DISTINCT
    TO_CHAR(rated_at, 'YYYYMMDD')::INT AS date_id,
    rated_at::DATE AS full_date,
    EXTRACT(YEAR FROM rated_at)::INT AS year,
    EXTRACT(MONTH FROM rated_at)::INT AS month,
    EXTRACT(DAY FROM rated_at)::INT AS day,
    EXTRACT(QUARTER FROM rated_at)::INT AS quarter,
    EXTRACT(ISODOW FROM rated_at)::INT AS day_of_week
FROM silver.stg_ratings
WHERE rated_at IS NOT NULL;

INSERT INTO gold.dim_time (time_id, full_time, hour, minute, second)
SELECT DISTINCT
    TO_CHAR(DATE_TRUNC('second', rated_at), 'HH24MISS')::INT AS time_id,
    DATE_TRUNC('second', rated_at)::TIME AS full_time,
    EXTRACT(HOUR FROM rated_at)::INT AS hour,
    EXTRACT(MINUTE FROM rated_at)::INT AS minute,
    EXTRACT(SECOND FROM rated_at)::INT AS second
FROM silver.stg_ratings
WHERE rated_at IS NOT NULL;

INSERT INTO gold.dim_user (user_id, age, age_group, gender, occupation, zip_code)
SELECT
    u.user_id,
    u.age,
    ag.age_group_name,
    u.gender,
    o.occupation_name,
    u.zip_code
FROM silver.stg_users u
LEFT JOIN silver.stg_age_group ag ON u.age = ag.age_group_id
LEFT JOIN silver.stg_occupations o ON u.occupation_id = o.occupation_id;

INSERT INTO gold.dim_movies (movie_id, title, release_year, genres)
SELECT
    m.movie_id,
    m.title,
    m.release_year,
    STRING_AGG(g.genre_name, ', ' ORDER BY g.genre_name) AS genres
FROM silver.stg_movies m
LEFT JOIN silver.stg_genres_movies gm ON m.movie_id = gm.movie_id
LEFT JOIN silver.stg_genres g ON gm.genre_id = g.genre_id
GROUP BY m.movie_id, m.title, m.release_year;

INSERT INTO gold.fact_rating (rating_id, user_id, movie_id, date_id, time_id, rating)
SELECT
    rating_id,
    user_id,
    movie_id,
    TO_CHAR(rated_at, 'YYYYMMDD')::INT AS date_id,
    TO_CHAR(DATE_TRUNC('second', rated_at), 'HH24MISS')::INT AS time_id,
    rating
FROM silver.stg_ratings;

COMMIT;