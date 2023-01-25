/* Query per year --- Buscá todas las películas filmadas en el año que naciste.*/
SELECT *
FROM movies
WHERE year = 1993

/* Query count --- Cuantas películas hay en la DB que sean del año 1982?*/

SELECT COUNT(*) as total
FROM movies
WHERE year = 1982;


/* --- Buscá actores que tengan el substring stack en su apellido*/
-- el %stack seria que termine en stack, stack% que comience con stack y 
-- %stack% que comience, en el medio o termine con stack
SELECT *
FROM actors
WHERE last_name
LIKE '%stack%';


-- Buscá los 10 nombres y apellidos más populares entre los actores. 
-- Cuantos actores tienen cada uno de esos nombres y apellidos?
-- Esta consulta puede involucrar múltiples queries.
-- GROUP BY se usa para grupar por algun atributo
-- ORDER BY ordenados por
-- LOWER() pone todos es minuscula ya que ne la DB tenemos mayusculas y minusc (case sensitive)
SELECT first_name, last_name, COUNT(*) as total
FROM actors
GROUP BY LOWER(first_name), LOWER(last_name)
ORDER BY total DESC
LIMIT 10;


-- Listá el top 100 de actores más activos junto con el número de roles que haya realizado.
-- Acá tenemos una combinación de tablas (actors y peliculas) con una tabla intermedia (roles)
SELECT a.first_name, a.last_name, COUNT(*) as total
FROM actors AS a
JOIN roles AS r ON a.id = r.actor_id
GROUP BY a.id
ORDER BY total DESC
LIMIT 100;


-- Cuantas películas tiene IMDB por género? Ordená la lista por el género menos popular.
-- ORDER BY es ASCENDENTE por defecto
SELECT genre, COUNT(*) AS total
FROM movies_genres
GROUP BY genre
ORDER BY total;


-- Listá el nombre y apellido de todos los actores que trabajaron en la película "Braveheart" de 1995, 
-- ordená la lista alfabéticamente por apellido. 
-- nombre y año de la peli estan en table movies, 
-- necesito llegar a traves de un tabla intermedia (roles)
SELECT a.first_name, a.last_name
FROM actors AS a
JOIN roles AS r ON a.id = r.actor_id
JOIN movies AS m ON r.movie_id = m.id  
WHERE m.name = 'Braveheart' AND m.year = 1995
ORDER BY a.last_name;


-- Listá todos los directores que dirigieron una película de género 'Film-Noir' 
-- en un año bisiesto (para reducir la complejidad, asumí que cualquier año divisible por cuatro es bisiesto). 
-- Tu consulta debería devolver el nombre del director, el nombre de la peli y el año. 
-- Todo ordenado por el nombre de la película.
SELECT d.first_name, d.last_name, m.name, m.year
FROM directors AS d
JOIN movies_directors AS md ON md.director_id = d.id
JOIN movies AS m ON m.id = md.movie_id
JOIN movies_genres AS mg ON m.id = mg.movie_id
WHERE mg.genre = 'Film-Noir' AND m.year % 4 = 0
ORDER BY m.name;


-- Listá todos los actores que hayan trabajado con Kevin Bacon en películas de Drama 
-- (incluí el título de la peli). Excluí al señor Bacon de los resultados.
-- En SQLite concatenamos con || 
SELECT a.first_name, a.last_name
FROM actors AS a
JOIN roles AS r ON a.id = r.actor_id
JOIN movies AS m ON r.movie_id = m.id
JOIN movies_genres AS mg ON m.id = mg.movie_id
WHERE mg.genre = 'Drama' AND m.id IN (
    SELECT r.movie_id
    FROM roles AS r
    JOIN actors AS a ON a.id = r.actor_id
    WHERE a.first_name = 'Kevin' AND a.last_name = 'Bacon'
)
AND (a.first_name || ' ' || a.last_name != 'Kevin Bacon');


-- Qué actores actuaron en una película antes de 1900 y también en una película después del 2000?
SELECT a.first_name, a.last_name
FROM actors AS a
WHERE a.id IN
    (
        SELECT r.actor_id
        FROM roles AS r
        JOIN movies AS m ON m.id = r.movie_id
        WHERE m.year < 1900
    )
    AND a.id IN
    (
        SELECT r.actor_id
        FROM roles AS r
        JOIN movies AS m ON m.id = r.movie_id
        WHERE m.year > 2000
    )
    ;


-- Buscá actores que actuaron en cinco o más roles en la misma película después del año 1990. 
-- Noten que los ROLES pueden tener duplicados ocasionales, sobre los cuales no estamos interesados: 
-- queremos actores que hayan tenido cinco o más roles DISTINTOS (DISTINCT cough cough) en la misma película. 
-- Escribí un query que retorne los nombres del actor, el título de la película 
-- y el número de roles (siempre debería ser > 5).
SELECT a.first_name, a.last_name, m.name, COUNT(DISTINCT(role)) AS total
FROM roles AS r
JOIN actors AS a ON a.id = r.actor_id
JOIN movies AS m ON m.id = r.movie_id
WHERE m.year > 1990
GROUP BY r.actor_id, r.movie_id
HAVING total > 5;


-- Para cada año, contá el número de películas en ese años que sólo tuvieron actrices femeninas.
SELECT year, COUNT(DISTINCT id) AS total
FROM movies 
WHERE id NOT IN 
    (
        SELECT movie_id
        FROM roles AS r
        JOIN actors AS a ON a.id = r.actor_id
        WHERE a.gender = 'M'
    ) 
GROUP BY year;

