CREATE TABLE IF NOT EXISTS public.usuario
(
    id_usuario bigserial NOT NULL,
    nombre_usuario character varying(255) NOT NULL,
    nombre_perfil character varying(255),
    correo character varying(255)NOT NULL,
    "contraseña" character varying(255),
    rol integer,
    foto_perfil character varying(255),
    biografia character varying(2000),
    CONSTRAINT usuario_pkey PRIMARY KEY (id_usuario),
    CONSTRAINT usuario_correo_key UNIQUE (correo)
);

CREATE TABLE IF NOT EXISTS public.coleccion
(
    id_coleccion bigserial NOT NULL,
    nombre character varying(255) NOT NULL,
    CONSTRAINT coleccion_pkey PRIMARY KEY (id_coleccion)
);
	
CREATE TABLE IF NOT EXISTS public.libro
(
    id_libro bigserial NOT NULL,
    titulo character varying(255) NOT NULL,
    autor character varying(255) NOT NULL,
    "año_publicacion" integer,
    numero_paginas integer NOT NULL,
    editorial character varying(255),
    sinopsis character varying(2000),
    portada character varying(2000),
    isbn character varying(255),
    activo boolean DEFAULT true,
    id_coleccion bigint,
    num_coleccion integer,
    CONSTRAINT libro_pkey PRIMARY KEY (id_libro),
    CONSTRAINT libro_isbn_key UNIQUE (isbn),
    CONSTRAINT fk_coleccion FOREIGN KEY (id_coleccion)
        REFERENCES public.coleccion (id_coleccion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS public.genero
(
    id_genero bigserial NOT NULL,
    nombre character varying(255) NOT NULL,
    CONSTRAINT genero_pkey PRIMARY KEY (id_genero)
);

CREATE TABLE IF NOT EXISTS public.libro_genero
(
    id_libro bigint NOT NULL,
    id_genero bigint NOT NULL,
    CONSTRAINT libro_genero_pkey PRIMARY KEY (id_libro, id_genero),
    CONSTRAINT libro_genero_id_genero_fkey FOREIGN KEY (id_genero)
        REFERENCES public.genero (id_genero) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT libro_genero_id_libro_fkey FOREIGN KEY (id_libro)
        REFERENCES public.libro (id_libro) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.libro_biblioteca
(
    id_usuario bigint NOT NULL,
    id_libro bigint NOT NULL,
    estado_lectura integer NOT NULL DEFAULT 0,
    fecha_inicio timestamp(6) without time zone,
    fecha_fin timestamp(6) without time zone,
    progreso integer,
    calificacion double precision,
    "reseña" character varying(2000),
    tipo_progreso character varying(255) DEFAULT 'porcentaje'::character varying,
    CONSTRAINT libro_biblioteca_pkey PRIMARY KEY (id_usuario, id_libro),
    CONSTRAINT libro_biblioteca_id_libro_fkey FOREIGN KEY (id_libro)
        REFERENCES public.libro (id_libro) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT libro_biblioteca_id_usuario_fkey FOREIGN KEY (id_usuario)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT libro_biblioteca_calificacion_check CHECK (calificacion >= 0::double precision AND calificacion <= 5::double precision),
    CONSTRAINT libro_biblioteca_tipo_progreso_check CHECK (tipo_progreso::text = ANY (ARRAY['porcentaje'::character varying::text, 'paginas'::character varying::text]))
);

CREATE INDEX IF NOT EXISTS idx_libro_biblioteca_usuario_libro
    ON public.libro_biblioteca USING btree
    (id_usuario ASC NULLS LAST, id_libro ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE TABLE IF NOT EXISTS public.formato
(
    id_formato bigserial NOT NULL,
    nombre character varying(255) NOT NULL,
    CONSTRAINT formato_pkey PRIMARY KEY (id_formato)
);

CREATE TABLE IF NOT EXISTS public.formato_usuario
(
    id_usuario bigint NOT NULL,
    id_libro bigint NOT NULL,
    id_formato bigint NOT NULL,
    CONSTRAINT formato_usuario_pkey PRIMARY KEY (id_usuario, id_libro, id_formato),
    CONSTRAINT formato_usuario_id_formato_fkey FOREIGN KEY (id_formato)
        REFERENCES public.formato (id_formato) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT formato_usuario_id_usuario_id_libro_fkey FOREIGN KEY (id_usuario, id_libro)
        REFERENCES public.libro_biblioteca (id_usuario, id_libro) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.tipo_objetivo
(
    id_tipo bigserial NOT NULL,
    nombre character varying(255) NOT NULL,
    CONSTRAINT tipo_objetivo_pkey PRIMARY KEY (id_tipo)
);

CREATE TABLE IF NOT EXISTS public.duracion_objetivo
(
    id_duracion bigserial NOT NULL,
    nombre character varying(255) NOT NULL,
    CONSTRAINT duracion_objetivo_pkey PRIMARY KEY (id_duracion)
);

CREATE TABLE IF NOT EXISTS public.objetivo
(
    id_objetivo bigserial NOT NULL,
    cantidad integer NOT NULL,
    cantidad_actual integer,
    fecha_inicio timestamp(6) without time zone,
    fecha_fin timestamp(6) without time zone,
    id_usuario bigint NOT NULL,
    id_tipo bigint NOT NULL,
    id_duracion bigint NOT NULL,
    CONSTRAINT objetivo_pkey PRIMARY KEY (id_objetivo),
    CONSTRAINT objetivo_id_duracion_fkey FOREIGN KEY (id_duracion)
        REFERENCES public.duracion_objetivo (id_duracion) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT objetivo_id_tipo_fkey FOREIGN KEY (id_tipo)
        REFERENCES public.tipo_objetivo (id_tipo) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT objetivo_id_usuario_fkey FOREIGN KEY (id_usuario)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);
	
CREATE TABLE IF NOT EXISTS public.lista
(
    id_lista bigserial NOT NULL,
    id_usuario bigint NOT NULL,
    nombre character varying(255) NOT NULL,
    descripcion character varying(2000),
    CONSTRAINT lista_pkey PRIMARY KEY (id_lista),
    CONSTRAINT lista_id_usuario_fkey FOREIGN KEY (id_usuario)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.genero_lista
(
    id_lista bigint NOT NULL,
    id_genero bigint NOT NULL,
    CONSTRAINT genero_lista_pkey PRIMARY KEY (id_lista, id_genero),
    CONSTRAINT genero_lista_id_genero_fkey FOREIGN KEY (id_genero)
        REFERENCES public.genero (id_genero) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT genero_lista_id_lista_fkey FOREIGN KEY (id_lista)
        REFERENCES public.lista (id_lista) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.libro_lista
(
    id_lista bigint NOT NULL,
    id_libro bigint NOT NULL,
    "fecha_añadido" timestamp(6) without time zone,
    CONSTRAINT libro_lista_pkey PRIMARY KEY (id_lista, id_libro),
    CONSTRAINT libro_lista_id_libro_fkey FOREIGN KEY (id_libro)
        REFERENCES public.libro (id_libro) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT libro_lista_id_lista_fkey FOREIGN KEY (id_lista)
        REFERENCES public.lista (id_lista) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.libro_favorito
(
    id_libro bigint NOT NULL,
    id_usuario bigint NOT NULL,
    CONSTRAINT libro_favorito_pkey PRIMARY KEY (id_libro, id_usuario),
    CONSTRAINT libro_favorito_id_libro_fkey FOREIGN KEY (id_libro)
        REFERENCES public.libro (id_libro) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT libro_favorito_id_usuario_fkey FOREIGN KEY (id_usuario)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.genero_favorito
(
    id_genero bigint NOT NULL,
    id_usuario bigint NOT NULL,
    CONSTRAINT genero_favorito_pkey PRIMARY KEY (id_genero, id_usuario),
    CONSTRAINT genero_favorito_id_genero_fkey FOREIGN KEY (id_genero)
        REFERENCES public.genero (id_genero) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT genero_favorito_id_usuario_fkey FOREIGN KEY (id_usuario)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.seguimiento
(
    id_seguidor bigint NOT NULL,
    id_seguido bigint NOT NULL,
    CONSTRAINT seguimiento_pkey PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT seguimiento_id_seguido_fkey FOREIGN KEY (id_seguido)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT seguimiento_id_seguidor_fkey FOREIGN KEY (id_seguidor)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT seguimiento_check CHECK (id_seguidor <> id_seguido)
);

CREATE TABLE IF NOT EXISTS public.sugerencia
(
    id_sugerencia bigserial NOT NULL,
    id_usuario bigint NOT NULL,
    titulo character varying(255) NOT NULL,
    autor character varying(255) NOT NULL,
    "año_publicacion" integer,
    fecha_enviada timestamp(6) without time zone,
    estado integer DEFAULT 0,
    activo boolean DEFAULT false,
    CONSTRAINT sugerencia_pkey PRIMARY KEY (id_sugerencia),
    CONSTRAINT sugerencia_id_usuario_fkey FOREIGN KEY (id_usuario)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.solicitud_autor
(
    id_solicitud bigserial NOT NULL,
    id_usuario bigint NOT NULL,
    nombre character varying(255),
    biografia character varying(2000),
    fecha_enviada timestamp(6) without time zone,
    estado integer DEFAULT 0,
    activo boolean DEFAULT false,
    CONSTRAINT solicitud_autor_pkey PRIMARY KEY (id_solicitud),
    CONSTRAINT solicitud_autor_id_usuario_fkey FOREIGN KEY (id_usuario)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.libro_solicitud
(
    id bigserial NOT NULL,
    id_solicitud bigint NOT NULL,
    titulo character varying(255) NOT NULL,
    "año_publicacion" integer NOT NULL,
    CONSTRAINT libro_solicitud_pkey PRIMARY KEY (id),
    CONSTRAINT libro_solicitud_id_solicitud_fkey FOREIGN KEY (id_solicitud)
        REFERENCES public.solicitud_autor (id_solicitud) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS public.libro_autor
(
    id_autor integer NOT NULL,
    id_libro integer NOT NULL,
    CONSTRAINT libro_autor_pkey PRIMARY KEY (id_autor, id_libro),
    CONSTRAINT libro_autor_id_autor_fkey FOREIGN KEY (id_autor)
        REFERENCES public.usuario (id_usuario) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT libro_autor_id_libro_fkey FOREIGN KEY (id_libro)
        REFERENCES public.libro (id_libro) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

insert into usuario (id_usuario,nombre_usuario,nombre_perfil,correo,contraseña,rol,foto_perfil,biografia)
values (2,"hectorlf","Héctor:)","hector@readtoowell.com","$2a$10$bPlIZOSckQOAC33pWnfMbupjXuKiprxZWtWKq2e3SbjGHrGzQ6Ld2",0,"https://res.cloudinary.com/dfrgrfw4c/image/upload/v1745683061/readtoowell/profilepics/73f45e1f89af74229228dbc4abce482a_b35khy.jpg","I hate it here, so take me to the lakes Take me to the lakes Where all of the poets went to die, I don't belong My beloved neither to you")