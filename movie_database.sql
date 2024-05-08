#Hiển thị ra bảng ratings
SELECT *
FROM ratings

#hiển thị bảng movies
SELECT *
FROM movies

#Chọn ra các bộ phim có rating > 4 và revenue > 50000000
select distinct movies.title, ratings.rating, movies.vote_average, movies.revenue
from movies inner join ratings on movies.index=ratings.index
where ratings.rating > 4 and revenue > 50000000
ORDER BY ratings.rating DESC;

