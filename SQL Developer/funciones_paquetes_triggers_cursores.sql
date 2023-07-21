/*-------------------------------------------------------------- 15 funciones ------------------------------------------------------------*/
/*Función 1: obtener todos los blogs de un usuario específico.*/.

CREATE OR REPLACE FUNCTION getBlogsByUserId(idUsuario IN NUMBER) RETURN SYS_REFCURSOR AS
  blogs_cursor SYS_REFCURSOR;
BEGIN
  OPEN blogs_cursor FOR
    SELECT * FROM "Blog" WHERE "Usuario" = idUsuario;
  RETURN blogs_cursor;
END;


/*Función 2: obtener todos los blogs de un tema específico.*/.
CREATE OR REPLACE FUNCTION getBlogsByTopicId(idTema IN NUMBER) RETURN SYS_REFCURSOR AS
  blogs_cursor SYS_REFCURSOR;
BEGIN
  OPEN blogs_cursor FOR
    SELECT * FROM "Blog" WHERE "Topic" = idTema;
  RETURN blogs_cursor;
END;


/*Función 3: obtener todos los comentarios de un post específico.*/.
CREATE OR REPLACE FUNCTION getCommentsByPostId(idPost IN NUMBER) RETURN SYS_REFCURSOR AS
  comments_cursor SYS_REFCURSOR;
BEGIN
  OPEN comments_cursor FOR
    SELECT * FROM "Comentario" WHERE "Post" = idPost;
  RETURN comments_cursor;
END;


/*Función 4: obtener todos los mensajes de una sala de chat específica.*/.
CREATE OR REPLACE FUNCTION getMessagesByRoomId(idSala IN NUMBER) RETURN SYS_REFCURSOR AS
  messages_cursor SYS_REFCURSOR;
BEGIN
  OPEN messages_cursor FOR
    SELECT * FROM "Mensaje" WHERE "Room" = idSala;
  RETURN messages_cursor;
END;


/*Función 5: obtener todos los usuarios de una sala de chat específica.*/.
CREATE OR REPLACE FUNCTION getUsersByRoomId(idSala IN NUMBER) RETURN SYS_REFCURSOR AS
  users_cursor SYS_REFCURSOR;
BEGIN
  OPEN users_cursor FOR
    SELECT U.* FROM "Usuario" U
    INNER JOIN "RoomUsuario" RU ON U."idUsuario" = RU."Usuario"
    WHERE RU."Room" = idSala;
  RETURN users_cursor;
END;


/*Función 6: crear un nuevo usuario.*/.
CREATE OR REPLACE FUNCTION createUser(
    primApellido IN NVARCHAR2,
    segApellido IN NVARCHAR2,
    correo IN NVARCHAR2,
    contrasenna IN NVARCHAR2,
    imagen IN NVARCHAR2
) RETURN NUMBER AS
  idUsuario NUMBER;
BEGIN
  INSERT INTO "Usuario" ("primApellido", "segApellido", "correo", "contrasenna", "image")
  VALUES (primApellido, segApellido, correo, contrasenna, imagen)
  RETURNING "idUsuario" INTO idUsuario;
  RETURN idUsuario;
END;


/*Función 7: crear un nuevo blog.*/.
CREATE OR REPLACE FUNCTION createBlog(
    image IN NVARCHAR2,
    idUsuario IN NUMBER,
    idTema IN NUMBER
) RETURN NUMBER AS
  idBlog NUMBER;
BEGIN
  INSERT INTO "Blog" ("image", "Usuario", "Topic")
  VALUES (image, idUsuario, idTema)
  RETURNING "idBlog" INTO idBlog;
  RETURN idBlog;
END;


/*Función 8: crear un nuevo post en un blog específico.*/.
CREATE OR REPLACE FUNCTION createPost(
    content IN NVARCHAR2,
    idBlog IN NUMBER
) RETURN NUMBER AS
  idPost NUMBER;
BEGIN
  INSERT INTO "Post" ("content", "Blog")
  VALUES (content, idBlog)
  RETURNING "idPost" INTO idPost;
  RETURN idPost;
END;


/*Función 9: crear un nuevo comentario en un post específico.*/.
CREATE OR REPLACE FUNCTION createComment(
    content IN NVARCHAR2,
    idPost IN NUMBER,
    idUsuario IN NUMBER
) RETURN NUMBER AS
  idComentario NUMBER;
BEGIN
  INSERT INTO "Comentario" ("content", "Post", "Usuario")
  VALUES (content, idPost, idUsuario)
  RETURNING "idComentario" INTO idComentario;
  RETURN idComentario;
END;


/*Función 10: crear una nueva sala de chat.*/.
CREATE OR REPLACE FUNCTION createRoom(
    nombre IN NVARCHAR2,
    descripcion IN NVARCHAR2,
    idUsuario IN NUMBER,
    idTema IN NUMBER
) RETURN NUMBER AS
  idSala NUMBER;
BEGIN
  INSERT INTO "Room" ("nombre", "description", "Usuario", "Topic")
  VALUES (nombre, descripcion, idUsuario, idTema)
  RETURNING "idRoom" INTO idSala;
  RETURN idSala;
END;


/*Función 11: añadir un usuario a una sala de chat existente.*/.
CREATE OR REPLACE FUNCTION addUserToRoom(
    idUsuario IN NUMBER,
    idSala IN NUMBER
) RETURN NUMBER AS
  idRoomUsuario NUMBER;
BEGIN
  INSERT INTO "RoomUsuario" ("Usuario", "Room")
  VALUES (idUsuario, idSala)
  RETURNING "idRoomUsuario" INTO idRoomUsuario;
  RETURN idRoomUsuario;
END;


/*Función 12: enviar un nuevo mensaje en una sala de chat específica.*/.
CREATE OR REPLACE FUNCTION sendMessage(
    content IN NVARCHAR2,
    idUsuario IN NUMBER,
    idSala IN NUMBER
) RETURN NUMBER AS
  idMensaje NUMBER;
BEGIN
  INSERT INTO "Mensaje" ("content", "Usuario", "Room")
  VALUES (content, idUsuario, idSala)
  RETURNING "idMensaje" INTO idMensaje;
  RETURN idMensaje;
END;


/*Función 13: actualizar los datos de un usuario.*/.
CREATE OR REPLACE FUNCTION updateUser(
    idUsuario IN NUMBER,
    primApellido IN NVARCHAR2,
    segApellido IN NVARCHAR2,
    correo IN NVARCHAR2,
    contrasenna IN NVARCHAR2,
    imagen IN NVARCHAR2
) RETURN NUMBER AS
BEGIN
  UPDATE "Usuario"
  SET "primApellido" = primApellido,
      "segApellido" = segApellido,
      "correo" = correo,
      "contrasenna" = contrasenna,
      "image" = imagen
  WHERE "idUsuario" = idUsuario;
  RETURN 1;
END;


/*Función 14: actualizar los datos de un blog.*/.
CREATE OR REPLACE FUNCTION updateBlog(
    idBlog IN NUMBER,
    image IN NVARCHAR2,
    idUsuario IN NUMBER,
    idTema IN NUMBER
) RETURN NUMBER AS
BEGIN
  UPDATE "Blog"
  SET "image" = image,
      "Usuario" = idUsuario,
      "Topic" = idTema
  WHERE "idBlog" = idBlog;
  RETURN 1;
END;


/*Función 15: actualizar el contenido de un post.*/.
CREATE OR REPLACE FUNCTION updatePost(
    idPost IN NUMBER,
    content IN NVARCHAR2
) RETURN NUMBER AS
BEGIN
  UPDATE "Post"
  SET "content" = content
  WHERE "idPost" = idPost;
  RETURN 1;
END;
/



/*-------------------------------------------------------------- 10 paquetes ------------------------------------------------------------*/
/*Paquete 1: operaciones con la tabla Admin.*/.
CREATE OR REPLACE PACKAGE AdminPackage AS
  FUNCTION getAdminById(idAdmin IN NUMBER) RETURN "Admin"%ROWTYPE;
END AdminPackage;


/*Paquete 2: operaciones con la tabla Usuario.*/.
CREATE OR REPLACE PACKAGE UsuarioPackage AS
  FUNCTION getUserById(idUsuario IN NUMBER) RETURN "Usuario"%ROWTYPE;
  FUNCTION getUserByEmail(correo IN NVARCHAR2) RETURN "Usuario"%ROWTYPE;
END UsuarioPackage;


/*Paquete 3: operaciones con la tabla Blog.*/.
CREATE OR REPLACE PACKAGE BlogPackage AS
  FUNCTION getBlogById(idBlog IN NUMBER) RETURN "Blog"%ROWTYPE;
  FUNCTION getBlogsByUserId(idUsuario IN NUMBER) RETURN SYS_REFCURSOR;
  FUNCTION getBlogsByTopicId(idTema IN NUMBER) RETURN SYS_REFCURSOR;
END BlogPackage;


/*Paquete 4: operaciones con la tabla Post.*/.
CREATE OR REPLACE PACKAGE PostPackage AS
  FUNCTION getPostById(idPost IN NUMBER) RETURN "Post"%ROWTYPE;
  FUNCTION getPostsByBlogId(idBlog IN NUMBER) RETURN SYS_REFCURSOR;
END PostPackage;


/*Paquete 5: operaciones con la tabla Comentario.*/.
CREATE OR REPLACE PACKAGE ComentarioPackage AS
  FUNCTION getCommentById(idComentario IN NUMBER) RETURN "Comentario"%ROWTYPE;
  FUNCTION getCommentsByPostId(idPost IN NUMBER) RETURN SYS_REFCURSOR;
END ComentarioPackage;


/*Paquete 6: operaciones con la tabla Room.*/.
CREATE OR REPLACE PACKAGE RoomPackage AS
  FUNCTION getRoomById(idRoom IN NUMBER) RETURN "Room"%ROWTYPE;
  FUNCTION getRoomsByUserId(idUsuario IN NUMBER) RETURN SYS_REFCURSOR;
END RoomPackage;


/*Paquete 7: operaciones con la tabla RoomUsuario.*/.
CREATE OR REPLACE PACKAGE RoomUsuarioPackage AS
  FUNCTION getUsersByRoomId(idSala IN NUMBER) RETURN SYS_REFCURSOR;
END RoomUsuarioPackage;


/*Paquete 8: operaciones con la tabla Mensaje.*/.
CREATE OR REPLACE PACKAGE MensajePackage AS
  FUNCTION getMessagesByRoomId(idSala IN NUMBER) RETURN SYS_REFCURSOR;
END MensajePackage;


/*Paquete 9: operaciones con la tabla Topic.*/.
CREATE OR REPLACE PACKAGE TopicPackage AS
  FUNCTION getTopicById(idTopic IN NUMBER) RETURN "Topic"%ROWTYPE;
  FUNCTION getTopicByName(nombre IN NVARCHAR2) RETURN "Topic"%ROWTYPE;
END TopicPackage;


/*Paquete 10: operaciones comunes en múltiples tablas.*/.
CREATE OR REPLACE PACKAGE CommonPackage AS
  FUNCTION getCommentsByUserId(idUsuario IN NUMBER) RETURN SYS_REFCURSOR;
  FUNCTION getPostsByUserId(idUsuario IN NUMBER) RETURN SYS_REFCURSOR;
  FUNCTION getCommentsByBlogId(idBlog IN NUMBER) RETURN SYS_REFCURSOR;
  FUNCTION getCommentsByTopicId(idTema IN NUMBER) RETURN SYS_REFCURSOR;
END CommonPackage;
/*-------------------------------------------------------------- 5 triggers ------------------------------------------------------------*/
/*Trigger 1: mantener actualizado el número de blogs de un usuario.*/.
CREATE OR REPLACE TRIGGER updateNumBlogs
AFTER INSERT OR UPDATE OR DELETE ON "Blog"
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    UPDATE "Usuario" SET "numBlogs" = "numBlogs" + 1 WHERE "idUsuario" = :NEW."Usuario";
  ELSIF UPDATING THEN
    UPDATE "Usuario" SET "numBlogs" = "numBlogs" + 1 WHERE "idUsuario" = :NEW."Usuario";
    UPDATE "Usuario" SET "numBlogs" = "numBlogs" - 1 WHERE "idUsuario" = :OLD."Usuario";
  ELSIF DELETING THEN
    UPDATE "Usuario" SET "numBlogs" = "numBlogs" - 1 WHERE "idUsuario" = :OLD."Usuario";
  END IF;
END;


/*Trigger 2: evitar eliminar un usuario con blogs asociados.*/.
CREATE OR REPLACE TRIGGER preventDeleteUserWithBlogs
BEFORE DELETE ON "Usuario"
FOR EACH ROW
DECLARE
  numBlogs NUMBER;
BEGIN
  SELECT COUNT(*) INTO numBlogs FROM "Blog" WHERE "Usuario" = :OLD."idUsuario";
  IF numBlogs > 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'No se puede eliminar el usuario porque tiene blogs asociados.');
  END IF;
END;


/*Trigger 3: registrar la fecha de creación de un blog.*/.
CREATE OR REPLACE TRIGGER setBlogCreationDate
BEFORE INSERT ON "Blog"
FOR EACH ROW
BEGIN
  :NEW."fechaCreacion" := SYSDATE;
END;


/*Trigger 4: mantener actualizado el número de comentarios de un post.*/.
CREATE OR REPLACE TRIGGER updateNumComments
AFTER INSERT OR UPDATE OR DELETE ON "Comentario"
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    UPDATE "Post" SET "numComments" = "numComments" + 1 WHERE "idPost" = :NEW."Post";
  ELSIF UPDATING THEN
    UPDATE "Post" SET "numComments" = "numComments" + 1 WHERE "idPost" = :NEW."Post";
    UPDATE "Post" SET "numComments" = "numComments" - 1 WHERE "idPost" = :OLD."Post";
  ELSIF DELETING THEN
    UPDATE "Post" SET "numComments" = "numComments" - 1 WHERE "idPost" = :OLD."Post";
  END IF;
END;


/*Trigger 5: mantener actualizado el número de miembros en una sala de chat.*/.
CREATE OR REPLACE TRIGGER updateNumMembers
AFTER INSERT OR UPDATE OR DELETE ON "RoomUsuario"
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    UPDATE "Room" SET "numMembers" = "numMembers" + 1 WHERE "idRoom" = :NEW."Room";
  ELSIF UPDATING THEN
    UPDATE "Room" SET "numMembers" = "numMembers" + 1 WHERE "idRoom" = :NEW."Room";
    UPDATE "Room" SET "numMembers" = "numMembers" - 1 WHERE "idRoom" = :OLD."Room";
  ELSIF DELETING THEN
    UPDATE "Room" SET "numMembers" = "numMembers" - 1 WHERE "idRoom" = :OLD."Room";
  END IF;
END;


/*-------------------------------------------------------------- 15 cursores ------------------------------------------------------------*/

/*Cursor 1: Obtener todos los usuarios.*/.

DECLARE
  CURSOR c_users IS
    SELECT * FROM "Usuario";
BEGIN
  FOR user_rec IN c_users LOOP
    DBMS_OUTPUT.PUT_LINE('ID: ' || user_rec.idUsuario || ', Nombre: ' || user_rec.primApellido || ' ' || user_rec.segApellido);
  END LOOP;
END;


/*Cursor 2: Obtener todos los blogs de un usuario específico.*/.
DECLARE
  v_user_id NUMBER := 1; -- ID del usuario específico
  CURSOR c_blogs IS
    SELECT * FROM "Blog" WHERE "Usuario" = v_user_id;
BEGIN
  FOR blog_rec IN c_blogs LOOP
    DBMS_OUTPUT.PUT_LINE('ID Blog: ' || blog_rec.idBlog || ', Usuario: ' || blog_rec.Usuario || ', Tema: ' || blog_rec.Topic);
  END LOOP;
END;


/*Cursor 3: Obtener todos los blogs de un tema específico.*/.
DECLARE
  v_topic_id NUMBER := 3; -- ID del tema específico
  CURSOR c_blogs IS
    SELECT * FROM "Blog" WHERE "Topic" = v_topic_id;
BEGIN
  FOR blog_rec IN c_blogs LOOP
    DBMS_OUTPUT.PUT_LINE('ID Blog: ' || blog_rec.idBlog || ', Usuario: ' || blog_rec.Usuario || ', Tema: ' || blog_rec.Topic);
  END LOOP;
END;


/*Cursor 4: Obtener todos los comentarios de un post específico.*/.
DECLARE
  v_post_id NUMBER := 2; -- ID del post específico
  CURSOR c_comments IS
    SELECT * FROM "Comentario" WHERE "Post" = v_post_id;
BEGIN
  FOR comment_rec IN c_comments LOOP
    DBMS_OUTPUT.PUT_LINE('ID Comentario: ' || comment_rec.idComentario || ', Post: ' || comment_rec.Post || ', Usuario: ' || comment_rec.Usuario);
  END LOOP;
END;


/*Cursor 5: Obtener todos los mensajes de una sala de chat específica.*/.
DECLARE
  v_room_id NUMBER := 4; -- ID de la sala de chat específica
  CURSOR c_messages IS
    SELECT * FROM "Mensaje" WHERE "Room" = v_room_id;
BEGIN
  FOR message_rec IN c_messages LOOP
    DBMS_OUTPUT.PUT_LINE('ID Mensaje: ' || message_rec.idMensaje || ', Sala: ' || message_rec.Room || ', Usuario: ' || message_rec.Usuario);
  END LOOP;
END;


/*Cursor 6: Obtener todos los usuarios de una sala de chat específica.*/.
DECLARE
  v_room_id NUMBER := 5; -- ID de la sala de chat específica
  CURSOR c_users_in_room IS
    SELECT U.* FROM "Usuario" U
    INNER JOIN "RoomUsuario" RU ON U."idUsuario" = RU."Usuario"
    WHERE RU."Room" = v_room_id;
BEGIN
  FOR user_rec IN c_users_in_room LOOP
    DBMS_OUTPUT.PUT_LINE('ID Usuario: ' || user_rec."idUsuario" || ', Nombre: ' || user_rec."primApellido" || ' ' || user_rec."segApellido");
  END LOOP;
END;

/*Cursor 7: Obtener todos los posts de un blog específico.*/.
DECLARE
  v_blog_id NUMBER := 3; -- ID del blog específico
  CURSOR c_posts IS
    SELECT * FROM "Post" WHERE "Blog" = v_blog_id;
BEGIN
  FOR post_rec IN c_posts LOOP
    DBMS_OUTPUT.PUT_LINE('ID Post: ' || post_rec."idPost" || ', Contenido: ' || post_rec."content");
  END LOOP;
END;


/*Cursor 8: Obtener todos los comentarios realizados por un usuario específico.*/.
DECLARE
  v_user_id NUMBER := 2; -- ID del usuario específico
  CURSOR c_comments_by_user IS
    SELECT * FROM "Comentario" WHERE "Usuario" = v_user_id;
BEGIN
  FOR comment_rec IN c_comments_by_user LOOP
    DBMS_OUTPUT.PUT_LINE('ID Comentario: ' || comment_rec."idComentario" || ', Contenido: ' || comment_rec."content" || ', Post: ' || comment_rec."Post");
  END LOOP;
END;


/*Cursor 9: Obtener todos los tags de un post específico.*/.
DECLARE
  v_post_id NUMBER := 4; -- ID del post específico
  CURSOR c_tags_by_post IS
    SELECT * FROM "Tag" WHERE "Post" = v_post_id;
BEGIN
  FOR tag_rec IN c_tags_by_post LOOP
    DBMS_OUTPUT.PUT_LINE('ID Tag: ' || tag_rec."idTago" || ', Nombre: ' || tag_rec."name");
  END LOOP;
END;


/*Cursor 10: Obtener todos los blogs creados por usuarios con un nombre específico.*/.
DECLARE
  v_user_name NVARCHAR2(255) := 'Pérez'; -- Nombre del usuario específico
  CURSOR c_blogs_by_user_name IS
    SELECT B.* FROM "Blog" B
    INNER JOIN "Usuario" U ON B."Usuario" = U."idUsuario"
    WHERE U."primApellido" = v_user_name;
BEGIN
  FOR blog_rec IN c_blogs_by_user_name LOOP
    DBMS_OUTPUT.PUT_LINE('ID Blog: ' || blog_rec."idBlog" || ', Usuario: ' || blog_rec."Usuario" || ', Tema: ' || blog_rec."Topic");
  END LOOP;
END;


/*Cursor 11: Obtener todos los usuarios que han realizado comentarios en un blog específico.*/.
DECLARE
  v_blog_id NUMBER := 2; -- ID del blog específico
  CURSOR c_users_with_comments IS
    SELECT U.* FROM "Usuario" U
    INNER JOIN "Comentario" C ON U."idUsuario" = C."Usuario"
    WHERE C."Post" = v_blog_id;
BEGIN
  FOR user_rec IN c_users_with_comments LOOP
    DBMS_OUTPUT.PUT_LINE('ID Usuario: ' || user_rec."idUsuario" || ', Nombre: ' || user_rec."primApellido" || ' ' || user_rec."segApellido");
  END LOOP;
END;


/*Cursor 12: Obtener todos los blogs que contienen un tag específico.*/.
DECLARE
  v_tag_name NVARCHAR2(255) := 'tecnología'; -- Nombre del tag específico
  CURSOR c_blogs_with_tag IS
    SELECT B.* FROM "Blog" B
    INNER JOIN "Tag" T ON B."idBlog" = T."Post"
    WHERE T."name" = v_tag_name;
BEGIN
  FOR blog_rec IN c_blogs_with_tag LOOP
    DBMS_OUTPUT.PUT_LINE('ID Blog: ' || blog_rec."idBlog" || ', Usuario: ' || blog_rec."Usuario" || ', Tema: ' || blog_rec."Topic");
  END LOOP;
END;


/*Cursor 13: Obtener todos los blogs de un tema específico creados por usuarios con un apellido específico.*/.
DECLARE
  v_topic_id NUMBER := 1; -- ID del tema específico
  v_user_lastname NVARCHAR2(255) := 'Gómez'; -- Apellido del usuario específico
  CURSOR c_blogs_by_topic_and_user IS
    SELECT B.* FROM "Blog" B
    INNER JOIN "Usuario" U ON B."Usuario" = U."idUsuario"
    WHERE B."Topic" = v_topic_id AND U."segApellido" = v_user_lastname;
BEGIN
  FOR blog_rec IN c_blogs_by_topic_and_user LOOP
    DBMS_OUTPUT.PUT_LINE('ID Blog: ' || blog_rec."idBlog" || ', Usuario: ' || blog_rec."Usuario" || ', Tema: ' || blog_rec."Topic");
  END LOOP;
END;


/*Cursor 14: Obtener todos los mensajes enviados por un usuario específico en una sala de chat específica.*/.
DECLARE
  v_user_id NUMBER := 3; -- ID del usuario específico
  v_room_id NUMBER := 5; -- ID de la sala de chat específica
  CURSOR c_messages_by_user_and_room IS
    SELECT * FROM "Mensaje" WHERE "Usuario" = v_user_id AND "Room" = v_room_id;
BEGIN
  FOR message_rec IN c_messages_by_user_and_room LOOP
    DBMS_OUTPUT.PUT_LINE('ID Mensaje: ' || message_rec."idMensaje" || ', Sala: ' || message_rec."Room");
  END LOOP;
END;


/*Cursor 15: Obtener todos los usuarios que no han creado ningún blog.*/.
DECLARE
  CURSOR c_users_without_blogs IS
    SELECT U.* FROM "Usuario" U
    LEFT JOIN "Blog" B ON U."idUsuario" = B."Usuario"
    WHERE B."idBlog" IS NULL;
BEGIN
  FOR user_rec IN c_users_without_blogs LOOP
    DBMS_OUTPUT.PUT_LINE('ID Usuario: ' || user_rec."idUsuario" || ', Nombre: ' || user_rec."primApellido" || ' ' || user_rec."segApellido");
  END LOOP;
END;
