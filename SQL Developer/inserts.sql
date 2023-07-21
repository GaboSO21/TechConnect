-- Inserts para la tabla "Admin"
INSERT INTO "Admin" ("idAdmin", "usuario", "correo", "contrasenna")
VALUES (1, 'admin1', 'admin1@empresa.com', 'password123');

INSERT INTO "Admin" ("idAdmin", "usuario", "correo", "contrasenna")
VALUES (2, 'admin2', 'admin2@empresa.com', 'secure456');

-- Inserts para la tabla "Usuario"
INSERT INTO "Usuario" ("idUsuario", "primApellido", "segApellido", "correo", "contrasenna", "image")
VALUES (1, 'Gómez', 'Sánchez', 'usuario1@empresa.com', 'user123', 'imagen1.jpg');

INSERT INTO "Usuario" ("idUsuario", "primApellido", "segApellido", "correo", "contrasenna", "image")
VALUES (2, 'Martínez', 'Pérez', 'usuario2@empresa.com', 'pass789', 'imagen2.jpg');

-- Inserts para la tabla "Topic"
INSERT INTO "Topic" ("idTopic", "nombre")
VALUES (1, 'Matemáticas');

INSERT INTO "Topic" ("idTopic", "nombre")
VALUES (2, 'Ciencias');

-- Inserts para la tabla "Blog"
INSERT INTO "Blog" ("idBlog", "name", "image", "Usuario", "Topic")
VALUES (1, 'Blog de Gomez', 'imagen_blog1.jpg', 1, 1);

INSERT INTO "Blog" ("idBlog", "name", "image", "Usuario", "Topic")
VALUES (2, 'Blog de Martínez', 'imagen_blog2.jpg', 2, 2);

-- Inserts para la tabla "Post"
INSERT INTO "Post" ("idPost", "content", "Blog")
VALUES (1, 'Contenido del primer post.', 1);

INSERT INTO "Post" ("idPost", "content", "Blog")
VALUES (2, 'Contenido del segundo post.', 2);

-- Inserts para la tabla "Tag"
INSERT INTO "Tag" ("idTag", "name", "Post")
VALUES (1, 'Etiqueta1', 1);

INSERT INTO "Tag" ("idTag", "name", "Post")
VALUES (2, 'Etiqueta2', 2);

-- Inserts para la tabla "Comentario"
INSERT INTO "Comentario" ("idComentario", "content", "Post", "Usuario")
VALUES (1, 'Comentario en el post 1.', 1, 1);

INSERT INTO "Comentario" ("idComentario", "content", "Post", "Usuario")
VALUES (2, 'Comentario en el post 2.', 2, 2);

-- Inserts para la tabla "Room"
INSERT INTO "Room" ("idRoom", "nombre", "description", "Usuario", "Topic")
VALUES (1, 'Sala 1', 'Descripción de la sala 1', 1, 1);

INSERT INTO "Room" ("idRoom", "nombre", "description", "Usuario", "Topic")
VALUES (2, 'Sala 2', 'Descripción de la sala 2', 2, 2);

-- Inserts para la tabla "RoomUsuario"
INSERT INTO "RoomUsuario" ("idRoomUsuario", "Usuario", "Room")
VALUES (1, 1, 1);

INSERT INTO "RoomUsuario" ("idRoomUsuario", "Usuario", "Room")
VALUES (2, 2, 2);

-- Inserts para la tabla "Mensaje"
INSERT INTO "Mensaje" ("idMensaje", "content", "Usuario", "Room")
VALUES (1, 'Mensaje en la sala 1.', 1, 1);

INSERT INTO "Mensaje" ("idMensaje", "content", "Usuario", "Room")
VALUES (2, 'Mensaje en la sala 2.', 2, 2);
