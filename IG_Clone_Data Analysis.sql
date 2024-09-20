CREATE TABLE oldest_users AS
SELECT * FROM users
ORDER BY created_at
LIMIT 5;

CREATE TABLE top_registration_days AS
SELECT
DAYNAME(created_at) AS day,
COUNT(*) AS total
FROM users
GROUP BY day
ORDER BY total DESC
LIMIT 2;

CREATE TABLE no_photos_users AS
SELECT username
FROM users
LEFT JOIN photos
ON users.id = photos.user_id
WHERE photos.id IS NULL;

CREATE TABLE most_liked_photo AS
SELECT
username,
photos.id,
photos.image_url,
COUNT(*) AS total
FROM photos
INNER JOIN likes
ON likes.photo_id = photos.id
INNER JOIN users
ON photos.user_id = users.id
GROUP BY photos.id
ORDER BY total DESC
LIMIT 1;

CREATE TABLE avg_photos_per_user AS
SELECT (SELECT Count(*)
FROM photos) / (SELECT Count(*)
FROM users) AS avg;

CREATE TABLE top_tags AS
SELECT tags.tag_name,
Count(*) AS total
FROM photo_tags
JOIN tags
ON photo_tags.tag_id = tags.id
GROUP BY tags.id
ORDER BY total DESC
LIMIT 5;

CREATE TABLE equal_likes_users AS
SELECT username,
Count(*) AS num_likes
FROM users
INNER JOIN likes
ON users.id = likes.user_id
GROUP BY likes.user_id
HAVING num_likes = (SELECT Count(*)
FROM photos);
-- Finally, you can query all the tables for a comprehensive view:
SELECT * FROM oldest_users;
SELECT * FROM top_registration_days;
SELECT * FROM no_photos_users;
SELECT * FROM most_liked_photo;
SELECT * FROM avg_photos_per_user;
SELECT * FROM top_tags;
SELECT * FROM equal_likes_users;