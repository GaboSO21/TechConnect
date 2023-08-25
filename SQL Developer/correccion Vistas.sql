
---------------------------------------
-------------------------vs1
CREATE OR REPLACE VIEW TopicsUsadosEnBlogs AS
SELECT
t."idTopic",
t."nombre",
COUNT(b."idBlog") AS "CantidadBlogs"
FROM
"Topic" t
JOIN
"Blog" b ON t."idTopic" = b."Topic"
GROUP BY
t."idTopic", t."nombre"
ORDER BY
"CantidadBlogs" DESC;

SELECT * FROM TopicsUsadosEnBlogs;
------------------------------vs2
CREATE OR REPLACE VIEW TopicsUsadosEnRooms AS
SELECT
 t."idTopic",
t."nombre",
COUNT(r."idRoom") AS "CantidadSalas"
FROM
"Topic" t
JOIN
"Room" r ON t."idTopic" = r."Topic"
GROUP BY
t."idTopic", t."nombre"
ORDER BY
"CantidadSalas" DESC;
    
 SELECT * FROM TopicsUsadosEnRooms;   
 
 ------------------------vs3
CREATE OR REPLACE VIEW RoomConMasUsuarios AS
SELECT
r."idRoom",
r."nombre",
COUNT(u."idUsuario") AS "CantidadUsuarios"
FROM"Room" r

JOIN "RoomUsuario" ru ON r."idRoom" = ru."Room"
JOIN  "Usuario" u ON ru."Usuario" = u."idUsuario"

GROUP BY r."idRoom", r."nombre"

ORDER BY"CantidadUsuarios" DESC
FETCH FIRST 1 ROWS ONLY;

SELECT * FROM RoomConMasUsuarios;
-------------------------vs4
CREATE OR REPLACE VIEW UsuarioConMasBlogs AS
SELECT
u."idUsuario",
u."primApellido" || ' ' || u."segApellido" AS "NombreCompleto",
COUNT(b."idBlog") AS "Cantidad de Blogs"
FROM
"Usuario" u
LEFT JOIN
"Blog" b ON u."idUsuario" = b."Usuario"
GROUP BY
u."idUsuario", u."primApellido", u."segApellido"
ORDER BY
"Cantidad de Blogs" DESC
FETCH FIRST ROW ONLY;

SELECT * FROM UsuarioConMasBlogs;

---------------------------vs5---

CREATE OR REPLACE VIEW UsuarioConMasComentarios AS
SELECT
u."idUsuario",
u."primApellido" || ' ' || u."segApellido" AS "NombreCompleto",
COUNT(c."idComentario") AS "Cantidad de Comentarios"
FROM
"Usuario" u
LEFT JOIN
"Comentario" c ON u."idUsuario" = c."Usuario"
GROUP BY
u."idUsuario", u."primApellido", u."segApellido"
ORDER BY
"Cantidad de Comentarios" DESC
FETCH FIRST ROW ONLY;

SELECT * FROM UsuarioConMasComentarios;

--------------------------vs6--------------// no logre hacer que funcione 
CREATE OR REPLACE VIEW BlogConMasPosts AS
SELECT
b."idBlog",
b."name" AS "NombreBlog",
   COUNT(p."idPost") AS "Cantidad de Posts"
FROM
"Blog" b
LEFT JOIN
"Post" p ON b."idBlog" = p."Blog"

ORDER BY
"Cantidad de Posts" DESC
FETCH FIRST ROW ONLY;

-------------------vs7
CREATE OR REPLACE VIEW RoomConMasMensajes AS
SELECT
r."idRoom",
r."nombre" AS "NombreRoom",
COUNT(m."idMensaje") AS "Cantidad de Mensajes"
FROM
"Room" r
LEFT JOIN
"Mensaje" m ON r."idRoom" = m."Room"

GROUP BY
r."idRoom", r."nombre"

ORDER BY
"Cantidad de Mensajes" DESC
FETCH FIRST ROW ONLY;

SELECT * FROM RoomConMasMensajes;

-----------------------------vs8
CREATE OR REPLACE VIEW UsuarioConMasSalas AS
SELECT
u."idUsuario",
u."primApellido" || ' ' || u."segApellido" AS "NombreCompleto",
COUNT(ru."idRoomUsuario") AS "Cantidad de Salas"
FROM
"Usuario" u
LEFT JOIN
"RoomUsuario" ru ON u."idUsuario" = ru."Usuario"
GROUP BY
u."idUsuario", u."primApellido", u."segApellido"
ORDER BY
"Cantidad de Salas" DESC
FETCH FIRST ROW ONLY;


SELECT * FROM UsuarioConMasSalas;
-----------------------------------vs9

CREATE OR REPLACE VIEW PostConMasComentarios AS
SELECT
p."idPost",
p."content" AS "Contenido de Post",
COUNT(c."idComentario") AS "Cantidad de Comentarios"

FROM
"Post" p
LEFT JOIN
 "Comentario" c ON p."idPost" = c."Post"
 
GROUP BY
p."idPost", p."content"
ORDER BY
"Cantidad de Comentarios" DESC

FETCH FIRST ROW ONLY;

SELECT * FROM PostConMasComentarios;
