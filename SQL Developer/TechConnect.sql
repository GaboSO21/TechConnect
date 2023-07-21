CREATE TABLE "Admin" (
  "idAdmin" NUMBER NOT NULL,
  "usuario" NVARCHAR2(255) NOT NULL,
  "correo" NVARCHAR2(255) NOT NULL,
  "contrasenna" NVARCHAR2(255) NOT NULL,
  PRIMARY KEY ("idAdmin")
);

CREATE TABLE "Usuario" (
  "idUsuario" NUMBER NOT NULL,
  "primApellido" NVARCHAR2(255) NOT NULL,
  "segApellido" NVARCHAR2(255) NOT NULL,
  "correo" NVARCHAR2(255) NOT NULL,
  "contrasenna" NVARCHAR2(255) NOT NULL,
  "image" NVARCHAR2(255),
  PRIMARY KEY ("idUsuario")
);

CREATE TABLE "Topic" (
  "idTopic" NUMBER NOT NULL,
  "nombre" NVARCHAR2(255) NOT NULL,
  PRIMARY KEY ("idTopic")
);

CREATE TABLE "Blog" (
  "idBlog" NUMBER NOT NULL,
  "name" NVARCHAR2(255) NOT NULL,
  "image" NVARCHAR2(255),
  "Usuario" NUMBER NOT NULL,
  "Topic" NUMBER NOT NULL,
  PRIMARY KEY ("idBlog"),
  FOREIGN KEY ("Usuario") REFERENCES "Usuario" ("idUsuario"),
  FOREIGN KEY ("Topic") REFERENCES "Topic" ("idTopic")
);

CREATE TABLE "Post" (
  "idPost" NUMBER NOT NULL,
  "content" NVARCHAR2(255) NOT NULL,
  "Blog" NUMBER NOT NULL,
  PRIMARY KEY ("idPost"),
  FOREIGN KEY ("Blog") REFERENCES "Blog" ("idBlog")
);

CREATE TABLE "Tag" (
  "idTag" NUMBER NOT NULL,
  "name" NVARCHAR2(255) NOT NULL,
  "Post" NUMBER NOT NULL,
  PRIMARY KEY ("idTago"),
  FOREIGN KEY ("Post") REFERENCES "Post" ("idPost")
);

CREATE TABLE "Comentario" (
  "idComentario" NUMBER NOT NULL,
  "content" NVARCHAR2(255) NOT NULL,
  "Post" NUMBER NOT NULL,
  "Usuario" NUMBER NOT NULL,
  PRIMARY KEY ("idComentario"),
  FOREIGN KEY ("Post") REFERENCES "Post" ("idPost"),
  FOREIGN KEY ("Usuario") REFERENCES "Usuario" ("idUsuario")
);

CREATE TABLE "Room" (
  "idRoom" NUMBER NOT NULL,
  "nombre" NVARCHAR2(255) NOT NULL,
  "description" NVARCHAR2(255) NOT NULL,
  "Usuario" NUMBER NOT NULL,
  "Topic" NUMBER NOT NULL,
  PRIMARY KEY ("idRoom"),
  FOREIGN KEY ("Usuario") REFERENCES "Usuario" ("idUsuario"),
  FOREIGN KEY ("Topic") REFERENCES "Topic" ("idTopic")
);

CREATE TABLE "RoomUsuario" (
  "idRoomUsuario" NUMBER NOT NULL,
  "Usuario" NUMBER NOT NULL,
  "Room" NUMBER NOT NULL,
  PRIMARY KEY ("idRoomUsuario"),
  FOREIGN KEY ("Usuario") REFERENCES "Usuario" ("idUsuario"),
  FOREIGN KEY ("Room") REFERENCES "Room" ("idRoom")
);

CREATE TABLE "Mensaje" (
  "idMensaje" NUMBER NOT NULL,
  "content" NVARCHAR2(255) NOT NULL,
  "Usuario" NUMBER NOT NULL,
  "Room" NUMBER NOT NULL,
  PRIMARY KEY ("idMensaje"),
  FOREIGN KEY ("Usuario") REFERENCES "Usuario" ("idUsuario"),
  FOREIGN KEY ("Room") REFERENCES "Room" ("idRoom")
);
