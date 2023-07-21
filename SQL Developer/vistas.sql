/*--------------------------------------------------------- 10 Vistas ------------------------------------------------------------------- */
/* listar todos los blogs con sus temas correspondientes:*/

CREATE VIEW vw1 AS
SELECT b."idBlog", b."image", u."idUsuario", u."primApellido" || ' ' || u."segApellido" AS "Autor",
       t."idTopic", t."nombre" AS "NombreTema"
FROM "Blog" b
JOIN "Usuario" u ON b."Usuario" = u."idUsuario"
JOIN "Topic" t ON b."Topic" = t."idTopic";

select * from vw1 ;
/* mostrar todos los posts con sus blogs asociados y autores:*/
CREATE VIEW vw2 AS
SELECT p."idPost", p."content", b."idBlog", b."image", u."idUsuario", u."primApellido" || ' ' || u."segApellido" AS "Autor"
FROM "Post" p
JOIN "Blog" b ON p."Blog" = b."idBlog"
JOIN "Usuario" u ON b."Usuario" = u."idUsuario";

select * from vw2 ;

/*mostrar todas las etiquetas y los posts asociados a ellas:*/

CREATE VIEW vw3 AS
SELECT t."idTago", t."name" AS "NombreEtiqueta", p."idPost", p."content"
FROM "Tag" t
JOIN "Post" p ON t."Post" = p."idPost";

select * from vw3 ;

/*listar todos los usuarios con sus respectivas salas:*/

CREATE VIEW vw4 AS
SELECT u."idUsuario", u."primApellido" || ' ' || u."segApellido" AS "NombreUsuario", r."idRoom", r."nombre" AS "NombreSala"
FROM "Usuario" u
JOIN "RoomUsuario" ru ON u."idUsuario" = ru."Usuario"
JOIN "Room" r ON ru."Room" = r."idRoom";

select * from vw4 ;

/*mostrar todos los comentarios junto con sus posts asociados*/

CREATE VIEW vw5 AS
SELECT c."idComentario", c."content", p."idPost", p."content" AS "ContenidoPost", u."idUsuario",
       u."primApellido" || ' ' || u."segApellido" AS "Autor"
FROM "Comentario" c
JOIN "Post" p ON c."Post" = p."idPost"
JOIN "Usuario" u ON c."Usuario" = u."idUsuario";

select * from vw5 ;

/*listar todas las salas con sus temas respectivos:*/
CREATE VIEW vw6 AS
SELECT r."idRoom", r."nombre" AS "NombreSala", r."description" AS "DescripcionSala", t."idTopic", t."nombre" AS "NombreTema"
FROM "Room" r
JOIN "Topic" t ON r."Topic" = t."idTopic";

select * from vw6 ;
/* mostrar todos los mensajes junto con sus salas asociadas y autores:*/

CREATE VIEW vw7 AS
SELECT m."idMensaje", m."content", r."idRoom", r."nombre" AS "NombreSala", u."idUsuario",
       u."primApellido" || ' ' || u."segApellido" AS "Autor"
FROM "Mensaje" m
JOIN "Room" r ON m."Room" = r."idRoom"
JOIN "Usuario" u ON m."Usuario" = u."idUsuario";


select * from vw7 ;
/* listar todos los usuarios y sus blogs:*/

CREATE VIEW vw8 AS
SELECT u."idUsuario", u."primApellido" || ' ' || u."segApellido" AS "NombreUsuario",
       b."idBlog", b."image", b."Topic", t."nombre" AS "NombreTema"
FROM "Usuario" u
LEFT JOIN "Blog" b ON u."idUsuario" = b."Usuario"
LEFT JOIN "Topic" t ON b."Topic" = t."idTopic";


select * from vw8 ;
/*mostrar todos los blogs junto con la cantidad de posts que tienen:*/

CREATE VIEW vw9 AS
SELECT b."idBlog", b."image", COUNT(p."idPost") AS "CantidadPosts"
FROM "Blog" b
LEFT JOIN "Post" p ON b."idBlog" = p."Blog"
GROUP BY b."idBlog", b."image";


select * from vw9 ;
/* mostrar todos los posts y sus etiquetas asociadas:*/

CREATE VIEW vw10 AS
SELECT p."idPost", p."content", t."idTago", t."name" AS "NombreEtiqueta"
FROM "Post" p
LEFT JOIN "Tag" t ON p."idPost" = t."Post";

select * from vw10 ;
