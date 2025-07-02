COPY Usuario (id_usuario, nombre_usuario, nombre_perfil, correo, contraseña, rol, foto_perfil, biografia)
FROM 'C:/bd/usuario.csv'
DELIMETER '|'
CSV HEADER;

COPY Coleccion (id_coleccion, nombre)
FROM 'C:/bd/coleccion.csv'
DELIMETER '|'
CSV HEADER;

COPY Libro (id_libro, titulo, autor, año_publicacion, numero_paginas, editorial, sinopsis, portada, isbn, id_coleccion, num_coleccion, activo)
FROM 'C:/bd/libro.csv'
DELIMETER '|'
CSV HEADER;

COPY Genero (id_genero, nombre)
FROM 'C:/bd/genero.csv'
DELIMETER '|'
CSV HEADER;

COPY Libro_Genero (id_libro, id_genero)
FROM 'C:/bd/libro_genero.csv'
DELIMETER '|'
CSV HEADER;

COPY Libro_Biblioteca (id_usuario, id_libro, estado_lectura, fecha_inicio, fecha_fin, progreso, calificacion, reseña, tipo_progreso)
FROM 'C:/bd/libro_biblioteca.csv'
DELIMETER '|'
CSV HEADER;

COPY Formato (id_formato, nombre)
FROM 'C:/bd/formato.csv'
DELIMETER '|'
CSV HEADER;

COPY Formato_Usuario (id_usuario, id_libro, id_formato)
FROM 'C:/bd/formato_usuario.csv'
DELIMETER '|'
CSV HEADER;

COPY Tipo_Objetivo (id_tipo, nombre)
FROM 'C:/bd/tipo_objetivo.csv'
DELIMETER '|'
CSV HEADER;

COPY Duracion_Objetivo (id_duracion, nombre)
FROM 'C:/bd/duracion_objetivo.csv'
DELIMETER '|'
CSV HEADER;

COPY Objetivo (id_objetivo, cantidad, cantidad_actual, fecha_inicio, fecha_fin, id_usuario, id_tipo, id_duracion)
FROM 'C:/bd/objetivo.csv'
DELIMETER '|'
CSV HEADER;

COPY Lista (id_lista, id_usuario, nombre, descripcion)
FROM 'C:/bd/lista.csv'
DELIMETER '|'
CSV HEADER;

COPY Genero_Lista (id_lista, id_genero)
FROM 'C:/bd/genero_lista.csv'
DELIMETER '|'
CSV HEADER;

COPY Libro_Lista (id_lista, id_libro, fecha_añadido)
FROM 'C:/bd/libro_lista.csv'
DELIMETER '|'
CSV HEADER;

COPY Libro_Favorito (id_usuario, id_libro)
FROM 'C:/bd/libro_favorito.csv'
DELIMETER '|'
CSV HEADER;

COPY Genero_Favorito (id_genero, id_usuario)
FROM 'C:/bd/genero_favorito.csv'
DELIMETER '|'
CSV HEADER;

COPY Seguimiento (id_seguidor, id_seguido)
FROM 'C:/bd/seguimiento.csv'
DELIMETER '|'
CSV HEADER;

COPY Sugerencia (id_sugerencia, id_usuario, titulo, autor, año_publicacion, fecha_enviada, estado, activo)
FROM 'C:/bd/sugerencia.csv'
DELIMETER '|'
CSV HEADER;

COPY Solicitud_Autor (id_solicitud, id_usuario, nombre, biografia, fecha_enviada, estado, activo)
FROM 'C:/bd/solicitud_autor.csv'
DELIMETER '|'
CSV HEADER;

COPY Libro_Solicitud ('id', id_solicitud, titulo, año_publicacion)
FROM 'C:/bd/libro_solicitud.csv'
DELIMETER '|'
CSV HEADER;

COPY Libro_Autor (id_autor, id_libro)
FROM 'C:/bd/libro_autor.csv'
DELIMETER '|'
CSV HEADER;