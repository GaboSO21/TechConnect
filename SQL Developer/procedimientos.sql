/*Consulta: Obtener todos los usuarios.*/
CREATE OR REPLACE PROCEDURE p1
AS
    CURSOR DATOS IS SELECT "AUTH_USER"."USERNAME" FROM "USUARIO" JOIN "AUTH_USER" ON "USUARIO"."USER_ID" = "AUTH_USER"."ID";
	usuario VARCHAR(50);
BEGIN
    OPEN DATOS;
		LOOP
            FETCH DATOS INTO usuario;
			EXIT WHEN DATOS%NOTFOUND;
			DBMS_OUTPUT.PUT_LINE('Usuario: ' || usuario );
		END LOOP;
	CLOSE DATOS;
END;

EXEC p1;

/*Consulta: Obtener todos los blogs de un usuario específico.*/
CREATE OR REPLACE PROCEDURE p2(idUsuario IN NUMBER)
AS
    CURSOR DATOS IS SELECT "Blog"."name" FROM "Blog" WHERE "Usuario"=idUsuario; 
BEGIN
	DBMS_OUTPUT.PUT_LINE('Blogs del usuario #' || idUsuario || ':');
	FOR B IN DATOS LOOP
		DBMS_OUTPUT.PUT_LINE( b."name" );
    END LOOP;
END;

EXEC p2(1);

/*Consulta: Obtener todos los blogs de un tema específico.*/
CREATE OR REPLACE PROCEDURE p3(idTema IN NUMBER)
AS
    CURSOR DATOS IS SELECT "Blog"."name" FROM "Blog" WHERE "Topic"=idTema;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Blogs con el tema #' || idTema || ':');
    FOR B IN DATOS LOOP
		DBMS_OUTPUT.PUT_LINE(B."name");
    END LOOP;
END;

EXEC p3(2);

/*Consulta: Obtener todos los comentarios de un post específico.*/
CREATE OR REPLACE PROCEDURE p4
    (idPost IN NUMBER)
AS
    CURSOR DATOS IS SELECT * FROM "Comentario" WHERE "Post"=idPost;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Comentarios del post #' || idPost || ':');
    FOR B IN DATOS LOOP
		DBMS_OUTPUT.PUT_LINE(B."content");
    END LOOP;
END;

EXEC p4(2);

/*Consulta: Obtener todos los mensajes de una sala de chat específica.*/
CREATE OR REPLACE PROCEDURE p5
    (idRoom IN NUMBER)
AS
    CURSOR DATOS IS SELECT * FROM "Mensaje" WHERE "Room"=idRoom;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Mensajes de la sala #' || idRoom || ':');
    FOR M IN DATOS LOOP
		DBMS_OUTPUT.PUT_LINE(M."content");
    END LOOP;
END;

EXEC p5(2);

/*Consulta: Obtener todos los usuarios de una sala de chat específica.*/
CREATE OR REPLACE PROCEDURE p6
    (idRoom IN NUMBER)
AS
     CURSOR DATOS IS SELECT "Usuario".* FROM "Usuario"
    				INNER JOIN "RoomUsuario" ON "Usuario"."idUsuario" = "RoomUsuario"."Usuario"
    				WHERE "RoomUsuario"."Room" = idRoom;
BEGIN
    DBMS_OUTPUT.PUT_LINE('Usuarios de la sala #' || idRoom || ':');
    FOR U IN DATOS LOOP
		DBMS_OUTPUT.PUT_LINE(U."primApellido" || ' ' || U."segApellido");
    END LOOP;
END;

EXEC p6(1);

/*Consulta: Obtener el post con mas comentarios .*/
CREATE OR REPLACE PROCEDURE p7
AS
    CURSOR DATOS IS SELECT "Post", COUNT("Post") AS "Frecuencia" FROM "Comentario" GROUP BY "Post" ORDER BY "Frecuencia";
    id NUMBER;
	cuentaNuevo NUMBER;
	cuentaViejo NUMBER := 0;
BEGIN
	FOR D IN DATOS LOOP
		cuentaNuevo := D."Frecuencia";
		IF cuentaNuevo > cuentaViejo THEN
            id := D."Post";
			cuentaViejo := D."Frecuencia";
        END IF;
    END LOOP;
	DBMS_OUTPUT.PUT_LINE( 'El post #' || id || ' tiene la mayor cantidad de comentarios, contando con: ' || cuentaViejo);
END;

EXEC p7;
/*Consulta: Obtener los tags mas utilizados en posts.*/

/*Consulta: Obtener todos los tags de un post específico.*/
CREATE OR REPLACE PROCEDURE p8
    (idPost INT)
AS
    CURSOR DATOS IS SELECT "Tag"."name" FROM "Tag" WHERE "Tag"."Post" = idPost;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Tags del post #' || idPost || ':');
	FOR T IN DATOS LOOP
		DBMS_OUTPUT.PUT_LINE( T."name" );
    END LOOP;
END;

EXEC p8(1);

/*Consulta: Obtener todos los comentarios realizados por un usuario específico.*/
CREATE OR REPLACE PROCEDURE p9
    (idUsuario INT)
AS
    CURSOR DATOS IS SELECT "Comentario"."content" FROM "Comentario" WHERE "Comentario"."Usuario" = idUsuario;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Comentarios del usuario #' || idUsuario || ':');
	FOR C IN DATOS LOOP
		DBMS_OUTPUT.PUT_LINE( C."content" );
    END LOOP;
END;

EXEC p9(1);
