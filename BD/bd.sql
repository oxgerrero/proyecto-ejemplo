toc.dat                                                                                             0000600 0004000 0002000 00000233374 14145571010 0014451 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP           &            
    y            bike    13.4    13.4 }    [           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         \           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         ]           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         ^           1262    17474    bike    DATABASE     c   CREATE DATABASE bike WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Colombia.1252';
    DROP DATABASE bike;
                postgres    false                     2615    17475    publicaciones    SCHEMA        CREATE SCHEMA publicaciones;
    DROP SCHEMA publicaciones;
                postgres    false                     2615    17476    security    SCHEMA        CREATE SCHEMA security;
    DROP SCHEMA security;
                postgres    false                     2615    17477    usuarios    SCHEMA        CREATE SCHEMA usuarios;
    DROP SCHEMA usuarios;
                postgres    false         ?            1255    17478    f_log_auditoria()    FUNCTION     ?  CREATE FUNCTION security.f_log_auditoria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
		_pk TEXT :='';		-- Representa la llave primaria de la tabla que esta siedno modificada.
		_sql TEXT;		-- Variable para la creacion del procedured.
		_column_guia RECORD; 	-- Variable para el FOR guarda los nombre de las columnas.
		_column_key RECORD; 	-- Variable para el FOR guarda los PK de las columnas.
		_session TEXT;	-- Almacena el usuario que genera el cambio.
		_user_db TEXT;		-- Almacena el usuario de bd que genera la transaccion.
		_control INT;		-- Variabel de control par alas llaves primarias.
		_count_key INT = 0;	-- Cantidad de columnas pertenecientes al PK.
		_sql_insert TEXT;	-- Variable para la construcción del insert del json de forma dinamica.
		_sql_delete TEXT;	-- Variable para la construcción del delete del json de forma dinamica.
		_sql_update TEXT;	-- Variable para la construcción del update del json de forma dinamica.
		_new_data RECORD; 	-- Fila que representa los campos nuevos del registro.
		_old_data RECORD;	-- Fila que representa los campos viejos del registro.

	BEGIN

			-- Se genera la evaluacion para determianr el tipo de accion sobre la tabla
		 IF (TG_OP = 'INSERT') THEN
			_new_data := NEW;
			_old_data := NEW;
		ELSEIF (TG_OP = 'UPDATE') THEN
			_new_data := NEW;
			_old_data := OLD;
		ELSE
			_new_data := OLD;
			_old_data := OLD;
		END IF;

		-- Se genera la evaluacion para determianr el tipo de accion sobre la tabla
		IF ((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME AND column_name = 'id' ) > 0) THEN
			_pk := _new_data.id;
		ELSE
			_pk := '-1';
		END IF;

		-- Se valida que exista el campo modified_by
		IF ((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME AND column_name = 'session') > 0) THEN
			_session := _new_data.session;
		ELSE
			_session := '';
		END IF;

		-- Se guarda el susuario de bd que genera la transaccion
		_user_db := (SELECT CURRENT_USER);

		-- Se evalua que exista el procedimeinto adecuado
		IF (SELECT COUNT(*) FROM security.function_db_view acfdv WHERE acfdv.b_function = 'field_audit' AND acfdv.b_type_parameters = TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', character varying, character varying, character varying, text, character varying, text, text') > 0
			THEN
				-- Se realiza la invocación del procedured generado dinamivamente
				PERFORM security.field_audit(_new_data, _old_data, TG_OP, _session, _user_db , _pk, ''::text);
		ELSE
			-- Se empieza la construcción del Procedured generico
			_sql := 'CREATE OR REPLACE FUNCTION security.field_audit( _data_new '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _data_old '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _accion character varying, _session text, _user_db character varying, _table_pk text, _init text)'
			|| ' RETURNS TEXT AS ''
'
			|| '
'
	|| '	DECLARE
'
	|| '		_column_data TEXT;
	 	_datos jsonb;
	 	
'
	|| '	BEGIN
			_datos = ''''{}'''';
';
			-- Se evalua si hay que actualizar la pk del registro de auditoria.
			IF _pk = '-1'
				THEN
					_sql := _sql
					|| '
		_column_data := ';

					-- Se genera el update con la clave pk de la tabla
					SELECT
						COUNT(isk.column_name)
					INTO
						_control
					FROM
						information_schema.table_constraints istc JOIN information_schema.key_column_usage isk ON isk.constraint_name = istc.constraint_name
					WHERE
						istc.table_schema = TG_TABLE_SCHEMA
					 AND	istc.table_name = TG_TABLE_NAME
					 AND	istc.constraint_type ilike '%primary%';

					-- Se agregan las columnas que componen la pk de la tabla.
					FOR _column_key IN SELECT
							isk.column_name
						FROM
							information_schema.table_constraints istc JOIN information_schema.key_column_usage isk ON isk.constraint_name = istc.constraint_name
						WHERE
							istc.table_schema = TG_TABLE_SCHEMA
						 AND	istc.table_name = TG_TABLE_NAME
						 AND	istc.constraint_type ilike '%primary%'
						ORDER BY 
							isk.ordinal_position  LOOP

						_sql := _sql || ' _data_new.' || _column_key.column_name;
						
						_count_key := _count_key + 1 ;
						
						IF _count_key < _control THEN
							_sql :=	_sql || ' || ' || ''''',''''' || ' ||';
						END IF;
					END LOOP;
				_sql := _sql || ';';
			END IF;

			_sql_insert:='
		IF _accion = ''''INSERT''''
			THEN
				';
			_sql_delete:='
		ELSEIF _accion = ''''DELETE''''
			THEN
				';
			_sql_update:='
		ELSE
			';

			-- Se genera el ciclo de agregado de columnas para el nuevo procedured
			FOR _column_guia IN SELECT column_name, data_type FROM information_schema.columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME
				LOOP
						
					_sql_insert:= _sql_insert || '_datos := _datos || json_build_object('''''
					|| _column_guia.column_name
					|| '_nuevo'
					|| ''''', '
					|| '_data_new.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea', 'USER-DEFINED') THEN 
						_sql_insert:= _sql_insert
						||'::text';
					END IF;

					_sql_insert:= _sql_insert || ')::jsonb;
				';

					_sql_delete := _sql_delete || '_datos := _datos || json_build_object('''''
					|| _column_guia.column_name
					|| '_anterior'
					|| ''''', '
					|| '_data_old.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea', 'USER-DEFINED') THEN 
						_sql_delete:= _sql_delete
						||'::text';
					END IF;

					_sql_delete:= _sql_delete || ')::jsonb;
				';

					_sql_update := _sql_update || 'IF _data_old.' || _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea','USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update || ' <> _data_new.' || _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea','USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update || '
				THEN _datos := _datos || json_build_object('''''
					|| _column_guia.column_name
					|| '_anterior'
					|| ''''', '
					|| '_data_old.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea','USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update
					|| ', '''''
					|| _column_guia.column_name
					|| '_nuevo'
					|| ''''', _data_new.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea', 'USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update
					|| ')::jsonb;
			END IF;
			';
			END LOOP;

			-- Se le agrega la parte final del procedured generico
			
			_sql:= _sql || _sql_insert || _sql_delete || _sql_update
			|| ' 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			''''' || TG_TABLE_SCHEMA || ''''',
			''''' || TG_TABLE_NAME || ''''',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;'''
|| '
LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION security.field_audit( _data_new '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _data_old '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) TO postgres;
';

			-- Se genera la ejecución de _sql, es decir se crea el nuevo procedured de forma generica.
			EXECUTE _sql;

		-- Se realiza la invocación del procedured generado dinamivamente
			 PERFORM security.field_audit(_new_data, _old_data, TG_OP::character varying, _session, _user_db, _pk, ''::text);

		END IF;

		RETURN NULL;

END;
$$;
 *   DROP FUNCTION security.f_log_auditoria();
       security          postgres    false    4         ?            1259    17480    historico_subastas    TABLE     ?   CREATE TABLE publicaciones.historico_subastas (
    id integer NOT NULL,
    id_comprador integer NOT NULL,
    id_subasta integer NOT NULL,
    valor integer NOT NULL
);
 -   DROP TABLE publicaciones.historico_subastas;
       publicaciones         heap    postgres    false    6         ?            1255    17483 ?   field_audit(publicaciones.historico_subastas, publicaciones.historico_subastas, character varying, text, character varying, text, text)    FUNCTION     ?  CREATE FUNCTION security.field_audit(_data_new publicaciones.historico_subastas, _data_old publicaciones.historico_subastas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('id_comprador_nuevo', _data_new.id_comprador)::jsonb;
				_datos := _datos || json_build_object('id_subasta_nuevo', _data_new.id_subasta)::jsonb;
				_datos := _datos || json_build_object('valor_nuevo', _data_new.valor)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador)::jsonb;
				_datos := _datos || json_build_object('id_subasta_anterior', _data_old.id_subasta)::jsonb;
				_datos := _datos || json_build_object('valor_anterior', _data_old.valor)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.id_comprador <> _data_new.id_comprador
				THEN _datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador, 'id_comprador_nuevo', _data_new.id_comprador)::jsonb;
			END IF;
			IF _data_old.id_subasta <> _data_new.id_subasta
				THEN _datos := _datos || json_build_object('id_subasta_anterior', _data_old.id_subasta, 'id_subasta_nuevo', _data_new.id_subasta)::jsonb;
			END IF;
			IF _data_old.valor <> _data_new.valor
				THEN _datos := _datos || json_build_object('valor_anterior', _data_old.valor, 'valor_nuevo', _data_new.valor)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'historico_subastas',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 ?   DROP FUNCTION security.field_audit(_data_new publicaciones.historico_subastas, _data_old publicaciones.historico_subastas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
       security          postgres    false    203    4    203         ?            1259    17484 
   inventario    TABLE     ?  CREATE TABLE publicaciones.inventario (
    id integer NOT NULL,
    imagen1 text NOT NULL,
    imagen2 text NOT NULL,
    imagen3 text NOT NULL,
    precio integer NOT NULL,
    status integer NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    modified_by time without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    talla text NOT NULL,
    referencia text NOT NULL,
    marca text NOT NULL,
    id_vendedor integer NOT NULL,
    id_comprador integer NOT NULL,
    fecha_revicion date NOT NULL,
    color text NOT NULL,
    "año" date NOT NULL,
    ciudad text NOT NULL,
    tipo_bicicleta text NOT NULL,
    tipo_frenos text NOT NULL,
    "n_piñones" text NOT NULL,
    correo boolean DEFAULT false NOT NULL
);
 %   DROP TABLE publicaciones.inventario;
       publicaciones         heap    postgres    false    6         ?            1255    17492 w   field_audit(publicaciones.inventario, publicaciones.inventario, character varying, text, character varying, text, text)    FUNCTION     0!  CREATE FUNCTION security.field_audit(_data_new publicaciones.inventario, _data_old publicaciones.inventario, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('imagen1_nuevo', _data_new.imagen1)::jsonb;
				_datos := _datos || json_build_object('imagen2_nuevo', _data_new.imagen2)::jsonb;
				_datos := _datos || json_build_object('imagen3_nuevo', _data_new.imagen3)::jsonb;
				_datos := _datos || json_build_object('precio_nuevo', _data_new.precio)::jsonb;
				_datos := _datos || json_build_object('status_nuevo', _data_new.status)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				_datos := _datos || json_build_object('talla_nuevo', _data_new.talla)::jsonb;
				_datos := _datos || json_build_object('referencia_nuevo', _data_new.referencia)::jsonb;
				_datos := _datos || json_build_object('marca_nuevo', _data_new.marca)::jsonb;
				_datos := _datos || json_build_object('id_vendedor_nuevo', _data_new.id_vendedor)::jsonb;
				_datos := _datos || json_build_object('id_comprador_nuevo', _data_new.id_comprador)::jsonb;
				_datos := _datos || json_build_object('fecha_revicion_nuevo', _data_new.fecha_revicion)::jsonb;
				_datos := _datos || json_build_object('color_nuevo', _data_new.color)::jsonb;
				_datos := _datos || json_build_object('año_nuevo', _data_new.año)::jsonb;
				_datos := _datos || json_build_object('ciudad_nuevo', _data_new.ciudad)::jsonb;
				_datos := _datos || json_build_object('tipo_bicicleta_nuevo', _data_new.tipo_bicicleta)::jsonb;
				_datos := _datos || json_build_object('tipo_frenos_nuevo', _data_new.tipo_frenos)::jsonb;
				_datos := _datos || json_build_object('n_piñones_nuevo', _data_new.n_piñones)::jsonb;
				_datos := _datos || json_build_object('correo_nuevo', _data_new.correo)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('imagen1_anterior', _data_old.imagen1)::jsonb;
				_datos := _datos || json_build_object('imagen2_anterior', _data_old.imagen2)::jsonb;
				_datos := _datos || json_build_object('imagen3_anterior', _data_old.imagen3)::jsonb;
				_datos := _datos || json_build_object('precio_anterior', _data_old.precio)::jsonb;
				_datos := _datos || json_build_object('status_anterior', _data_old.status)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				_datos := _datos || json_build_object('talla_anterior', _data_old.talla)::jsonb;
				_datos := _datos || json_build_object('referencia_anterior', _data_old.referencia)::jsonb;
				_datos := _datos || json_build_object('marca_anterior', _data_old.marca)::jsonb;
				_datos := _datos || json_build_object('id_vendedor_anterior', _data_old.id_vendedor)::jsonb;
				_datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador)::jsonb;
				_datos := _datos || json_build_object('fecha_revicion_anterior', _data_old.fecha_revicion)::jsonb;
				_datos := _datos || json_build_object('color_anterior', _data_old.color)::jsonb;
				_datos := _datos || json_build_object('año_anterior', _data_old.año)::jsonb;
				_datos := _datos || json_build_object('ciudad_anterior', _data_old.ciudad)::jsonb;
				_datos := _datos || json_build_object('tipo_bicicleta_anterior', _data_old.tipo_bicicleta)::jsonb;
				_datos := _datos || json_build_object('tipo_frenos_anterior', _data_old.tipo_frenos)::jsonb;
				_datos := _datos || json_build_object('n_piñones_anterior', _data_old.n_piñones)::jsonb;
				_datos := _datos || json_build_object('correo_anterior', _data_old.correo)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.imagen1 <> _data_new.imagen1
				THEN _datos := _datos || json_build_object('imagen1_anterior', _data_old.imagen1, 'imagen1_nuevo', _data_new.imagen1)::jsonb;
			END IF;
			IF _data_old.imagen2 <> _data_new.imagen2
				THEN _datos := _datos || json_build_object('imagen2_anterior', _data_old.imagen2, 'imagen2_nuevo', _data_new.imagen2)::jsonb;
			END IF;
			IF _data_old.imagen3 <> _data_new.imagen3
				THEN _datos := _datos || json_build_object('imagen3_anterior', _data_old.imagen3, 'imagen3_nuevo', _data_new.imagen3)::jsonb;
			END IF;
			IF _data_old.precio <> _data_new.precio
				THEN _datos := _datos || json_build_object('precio_anterior', _data_old.precio, 'precio_nuevo', _data_new.precio)::jsonb;
			END IF;
			IF _data_old.status <> _data_new.status
				THEN _datos := _datos || json_build_object('status_anterior', _data_old.status, 'status_nuevo', _data_new.status)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			IF _data_old.talla <> _data_new.talla
				THEN _datos := _datos || json_build_object('talla_anterior', _data_old.talla, 'talla_nuevo', _data_new.talla)::jsonb;
			END IF;
			IF _data_old.referencia <> _data_new.referencia
				THEN _datos := _datos || json_build_object('referencia_anterior', _data_old.referencia, 'referencia_nuevo', _data_new.referencia)::jsonb;
			END IF;
			IF _data_old.marca <> _data_new.marca
				THEN _datos := _datos || json_build_object('marca_anterior', _data_old.marca, 'marca_nuevo', _data_new.marca)::jsonb;
			END IF;
			IF _data_old.id_vendedor <> _data_new.id_vendedor
				THEN _datos := _datos || json_build_object('id_vendedor_anterior', _data_old.id_vendedor, 'id_vendedor_nuevo', _data_new.id_vendedor)::jsonb;
			END IF;
			IF _data_old.id_comprador <> _data_new.id_comprador
				THEN _datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador, 'id_comprador_nuevo', _data_new.id_comprador)::jsonb;
			END IF;
			IF _data_old.fecha_revicion <> _data_new.fecha_revicion
				THEN _datos := _datos || json_build_object('fecha_revicion_anterior', _data_old.fecha_revicion, 'fecha_revicion_nuevo', _data_new.fecha_revicion)::jsonb;
			END IF;
			IF _data_old.color <> _data_new.color
				THEN _datos := _datos || json_build_object('color_anterior', _data_old.color, 'color_nuevo', _data_new.color)::jsonb;
			END IF;
			IF _data_old.año <> _data_new.año
				THEN _datos := _datos || json_build_object('año_anterior', _data_old.año, 'año_nuevo', _data_new.año)::jsonb;
			END IF;
			IF _data_old.ciudad <> _data_new.ciudad
				THEN _datos := _datos || json_build_object('ciudad_anterior', _data_old.ciudad, 'ciudad_nuevo', _data_new.ciudad)::jsonb;
			END IF;
			IF _data_old.tipo_bicicleta <> _data_new.tipo_bicicleta
				THEN _datos := _datos || json_build_object('tipo_bicicleta_anterior', _data_old.tipo_bicicleta, 'tipo_bicicleta_nuevo', _data_new.tipo_bicicleta)::jsonb;
			END IF;
			IF _data_old.tipo_frenos <> _data_new.tipo_frenos
				THEN _datos := _datos || json_build_object('tipo_frenos_anterior', _data_old.tipo_frenos, 'tipo_frenos_nuevo', _data_new.tipo_frenos)::jsonb;
			END IF;
			IF _data_old.n_piñones <> _data_new.n_piñones
				THEN _datos := _datos || json_build_object('n_piñones_anterior', _data_old.n_piñones, 'n_piñones_nuevo', _data_new.n_piñones)::jsonb;
			END IF;
			IF _data_old.correo <> _data_new.correo
				THEN _datos := _datos || json_build_object('correo_anterior', _data_old.correo, 'correo_nuevo', _data_new.correo)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'inventario',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 ?   DROP FUNCTION security.field_audit(_data_new publicaciones.inventario, _data_old publicaciones.inventario, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
       security          postgres    false    4    204    204         ?            1259    17493    piniones    TABLE     `   CREATE TABLE publicaciones.piniones (
    id integer NOT NULL,
    descripcion text NOT NULL
);
 #   DROP TABLE publicaciones.piniones;
       publicaciones         heap    postgres    false    6         ?            1255    17499 s   field_audit(publicaciones.piniones, publicaciones.piniones, character varying, text, character varying, text, text)    FUNCTION     ?  CREATE FUNCTION security.field_audit(_data_new publicaciones.piniones, _data_old publicaciones.piniones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('descripcion_nuevo', _data_new.descripcion)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.descripcion <> _data_new.descripcion
				THEN _datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion, 'descripcion_nuevo', _data_new.descripcion)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'piniones',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 ?   DROP FUNCTION security.field_audit(_data_new publicaciones.piniones, _data_old publicaciones.piniones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
       security          postgres    false    205    205    4         ?            1259    17500    pqrs    TABLE     A  CREATE TABLE publicaciones.pqrs (
    id integer NOT NULL,
    id_publicacion integer NOT NULL,
    id_cliente_reporto integer NOT NULL,
    descripcion text NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    modified_by timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status integer
);
    DROP TABLE publicaciones.pqrs;
       publicaciones         heap    postgres    false    6         ?            1255    17508 k   field_audit(publicaciones.pqrs, publicaciones.pqrs, character varying, text, character varying, text, text)    FUNCTION     j  CREATE FUNCTION security.field_audit(_data_new publicaciones.pqrs, _data_old publicaciones.pqrs, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('id_publicacion_nuevo', _data_new.id_publicacion)::jsonb;
				_datos := _datos || json_build_object('id_cliente_reporto_nuevo', _data_new.id_cliente_reporto)::jsonb;
				_datos := _datos || json_build_object('descripcion_nuevo', _data_new.descripcion)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				_datos := _datos || json_build_object('status_nuevo', _data_new.status)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('id_publicacion_anterior', _data_old.id_publicacion)::jsonb;
				_datos := _datos || json_build_object('id_cliente_reporto_anterior', _data_old.id_cliente_reporto)::jsonb;
				_datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				_datos := _datos || json_build_object('status_anterior', _data_old.status)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.id_publicacion <> _data_new.id_publicacion
				THEN _datos := _datos || json_build_object('id_publicacion_anterior', _data_old.id_publicacion, 'id_publicacion_nuevo', _data_new.id_publicacion)::jsonb;
			END IF;
			IF _data_old.id_cliente_reporto <> _data_new.id_cliente_reporto
				THEN _datos := _datos || json_build_object('id_cliente_reporto_anterior', _data_old.id_cliente_reporto, 'id_cliente_reporto_nuevo', _data_new.id_cliente_reporto)::jsonb;
			END IF;
			IF _data_old.descripcion <> _data_new.descripcion
				THEN _datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion, 'descripcion_nuevo', _data_new.descripcion)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			IF _data_old.status <> _data_new.status
				THEN _datos := _datos || json_build_object('status_anterior', _data_old.status, 'status_nuevo', _data_new.status)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'pqrs',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 ?   DROP FUNCTION security.field_audit(_data_new publicaciones.pqrs, _data_old publicaciones.pqrs, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
       security          postgres    false    4    206    206         ?            1259    17509    subasta    TABLE        CREATE TABLE publicaciones.subasta (
    id integer NOT NULL,
    valor_inicial integer NOT NULL,
    status integer NOT NULL,
    puja_alta integer NOT NULL,
    id_producto integer NOT NULL,
    id_cliente integer NOT NULL,
    fecha_inicio timestamp without time zone NOT NULL,
    fecha_fin timestamp without time zone NOT NULL,
    modified_by timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    id_comprador integer NOT NULL,
    correo boolean DEFAULT false NOT NULL
);
 "   DROP TABLE publicaciones.subasta;
       publicaciones         heap    postgres    false    6         ?            1255    17517 q   field_audit(publicaciones.subasta, publicaciones.subasta, character varying, text, character varying, text, text)    FUNCTION     ?  CREATE FUNCTION security.field_audit(_data_new publicaciones.subasta, _data_old publicaciones.subasta, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('valor_inicial_nuevo', _data_new.valor_inicial)::jsonb;
				_datos := _datos || json_build_object('status_nuevo', _data_new.status)::jsonb;
				_datos := _datos || json_build_object('puja_alta_nuevo', _data_new.puja_alta)::jsonb;
				_datos := _datos || json_build_object('id_producto_nuevo', _data_new.id_producto)::jsonb;
				_datos := _datos || json_build_object('id_cliente_nuevo', _data_new.id_cliente)::jsonb;
				_datos := _datos || json_build_object('fecha_inicio_nuevo', _data_new.fecha_inicio)::jsonb;
				_datos := _datos || json_build_object('fecha_fin_nuevo', _data_new.fecha_fin)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('id_comprador_nuevo', _data_new.id_comprador)::jsonb;
				_datos := _datos || json_build_object('correo_nuevo', _data_new.correo)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('valor_inicial_anterior', _data_old.valor_inicial)::jsonb;
				_datos := _datos || json_build_object('status_anterior', _data_old.status)::jsonb;
				_datos := _datos || json_build_object('puja_alta_anterior', _data_old.puja_alta)::jsonb;
				_datos := _datos || json_build_object('id_producto_anterior', _data_old.id_producto)::jsonb;
				_datos := _datos || json_build_object('id_cliente_anterior', _data_old.id_cliente)::jsonb;
				_datos := _datos || json_build_object('fecha_inicio_anterior', _data_old.fecha_inicio)::jsonb;
				_datos := _datos || json_build_object('fecha_fin_anterior', _data_old.fecha_fin)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador)::jsonb;
				_datos := _datos || json_build_object('correo_anterior', _data_old.correo)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.valor_inicial <> _data_new.valor_inicial
				THEN _datos := _datos || json_build_object('valor_inicial_anterior', _data_old.valor_inicial, 'valor_inicial_nuevo', _data_new.valor_inicial)::jsonb;
			END IF;
			IF _data_old.status <> _data_new.status
				THEN _datos := _datos || json_build_object('status_anterior', _data_old.status, 'status_nuevo', _data_new.status)::jsonb;
			END IF;
			IF _data_old.puja_alta <> _data_new.puja_alta
				THEN _datos := _datos || json_build_object('puja_alta_anterior', _data_old.puja_alta, 'puja_alta_nuevo', _data_new.puja_alta)::jsonb;
			END IF;
			IF _data_old.id_producto <> _data_new.id_producto
				THEN _datos := _datos || json_build_object('id_producto_anterior', _data_old.id_producto, 'id_producto_nuevo', _data_new.id_producto)::jsonb;
			END IF;
			IF _data_old.id_cliente <> _data_new.id_cliente
				THEN _datos := _datos || json_build_object('id_cliente_anterior', _data_old.id_cliente, 'id_cliente_nuevo', _data_new.id_cliente)::jsonb;
			END IF;
			IF _data_old.fecha_inicio <> _data_new.fecha_inicio
				THEN _datos := _datos || json_build_object('fecha_inicio_anterior', _data_old.fecha_inicio, 'fecha_inicio_nuevo', _data_new.fecha_inicio)::jsonb;
			END IF;
			IF _data_old.fecha_fin <> _data_new.fecha_fin
				THEN _datos := _datos || json_build_object('fecha_fin_anterior', _data_old.fecha_fin, 'fecha_fin_nuevo', _data_new.fecha_fin)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.id_comprador <> _data_new.id_comprador
				THEN _datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador, 'id_comprador_nuevo', _data_new.id_comprador)::jsonb;
			END IF;
			IF _data_old.correo <> _data_new.correo
				THEN _datos := _datos || json_build_object('correo_anterior', _data_old.correo, 'correo_nuevo', _data_new.correo)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'subasta',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 ?   DROP FUNCTION security.field_audit(_data_new publicaciones.subasta, _data_old publicaciones.subasta, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
       security          postgres    false    207    4    207         ?            1259    17518    tipo_bicicleta    TABLE     f   CREATE TABLE publicaciones.tipo_bicicleta (
    id integer NOT NULL,
    descripcion text NOT NULL
);
 )   DROP TABLE publicaciones.tipo_bicicleta;
       publicaciones         heap    postgres    false    6         ?            1255    17524    field_audit(publicaciones.tipo_bicicleta, publicaciones.tipo_bicicleta, character varying, text, character varying, text, text)    FUNCTION     ?  CREATE FUNCTION security.field_audit(_data_new publicaciones.tipo_bicicleta, _data_old publicaciones.tipo_bicicleta, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('descripcion_nuevo', _data_new.descripcion)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.descripcion <> _data_new.descripcion
				THEN _datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion, 'descripcion_nuevo', _data_new.descripcion)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'tipo_bicicleta',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 ?   DROP FUNCTION security.field_audit(_data_new publicaciones.tipo_bicicleta, _data_old publicaciones.tipo_bicicleta, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
       security          postgres    false    4    208    208         ?            1259    17525    rol    TABLE     ?   CREATE TABLE usuarios.rol (
    id integer NOT NULL,
    desripcion text NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    modified_by time without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);
    DROP TABLE usuarios.rol;
       usuarios         heap    postgres    false    8         ?            1255    17533 _   field_audit(usuarios.rol, usuarios.rol, character varying, text, character varying, text, text)    FUNCTION     i  CREATE FUNCTION security.field_audit(_data_new usuarios.rol, _data_old usuarios.rol, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('desripcion_nuevo', _data_new.desripcion)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('desripcion_anterior', _data_old.desripcion)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.desripcion <> _data_new.desripcion
				THEN _datos := _datos || json_build_object('desripcion_anterior', _data_old.desripcion, 'desripcion_nuevo', _data_new.desripcion)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'usuarios',
			'rol',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 ?   DROP FUNCTION security.field_audit(_data_new usuarios.rol, _data_old usuarios.rol, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
       security          postgres    false    209    4    209         ?            1259    17534    token    TABLE     ?   CREATE TABLE usuarios.token (
    id integer NOT NULL,
    finicio timestamp without time zone NOT NULL,
    ffin timestamp without time zone NOT NULL,
    tactivo text NOT NULL,
    id_user integer NOT NULL
);
    DROP TABLE usuarios.token;
       usuarios         heap    postgres    false    8         ?            1255    17540 c   field_audit(usuarios.token, usuarios.token, character varying, text, character varying, text, text)    FUNCTION     t	  CREATE FUNCTION security.field_audit(_data_new usuarios.token, _data_old usuarios.token, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('finicio_nuevo', _data_new.finicio)::jsonb;
				_datos := _datos || json_build_object('ffin_nuevo', _data_new.ffin)::jsonb;
				_datos := _datos || json_build_object('tactivo_nuevo', _data_new.tactivo)::jsonb;
				_datos := _datos || json_build_object('id_user_nuevo', _data_new.id_user)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('finicio_anterior', _data_old.finicio)::jsonb;
				_datos := _datos || json_build_object('ffin_anterior', _data_old.ffin)::jsonb;
				_datos := _datos || json_build_object('tactivo_anterior', _data_old.tactivo)::jsonb;
				_datos := _datos || json_build_object('id_user_anterior', _data_old.id_user)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.finicio <> _data_new.finicio
				THEN _datos := _datos || json_build_object('finicio_anterior', _data_old.finicio, 'finicio_nuevo', _data_new.finicio)::jsonb;
			END IF;
			IF _data_old.ffin <> _data_new.ffin
				THEN _datos := _datos || json_build_object('ffin_anterior', _data_old.ffin, 'ffin_nuevo', _data_new.ffin)::jsonb;
			END IF;
			IF _data_old.tactivo <> _data_new.tactivo
				THEN _datos := _datos || json_build_object('tactivo_anterior', _data_old.tactivo, 'tactivo_nuevo', _data_new.tactivo)::jsonb;
			END IF;
			IF _data_old.id_user <> _data_new.id_user
				THEN _datos := _datos || json_build_object('id_user_anterior', _data_old.id_user, 'id_user_nuevo', _data_new.id_user)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'usuarios',
			'token',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 ?   DROP FUNCTION security.field_audit(_data_new usuarios.token, _data_old usuarios.token, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
       security          postgres    false    210    4    210         ?            1259    17541    usuarios    TABLE     ?  CREATE TABLE usuarios.usuarios (
    id integer NOT NULL,
    nombre text NOT NULL,
    apellido text NOT NULL,
    email text NOT NULL,
    usuario text NOT NULL,
    id_rol integer NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    modified_by time without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "contraseña" text NOT NULL,
    telefono text NOT NULL,
    activo integer NOT NULL,
    validado boolean DEFAULT false NOT NULL
);
    DROP TABLE usuarios.usuarios;
       usuarios         heap    postgres    false    8         ?            1255    17550 i   field_audit(usuarios.usuarios, usuarios.usuarios, character varying, text, character varying, text, text)    FUNCTION     ?  CREATE FUNCTION security.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('nombre_nuevo', _data_new.nombre)::jsonb;
				_datos := _datos || json_build_object('apellido_nuevo', _data_new.apellido)::jsonb;
				_datos := _datos || json_build_object('email_nuevo', _data_new.email)::jsonb;
				_datos := _datos || json_build_object('usuario_nuevo', _data_new.usuario)::jsonb;
				_datos := _datos || json_build_object('id_rol_nuevo', _data_new.id_rol)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				_datos := _datos || json_build_object('contraseña_nuevo', _data_new.contraseña)::jsonb;
				_datos := _datos || json_build_object('telefono_nuevo', _data_new.telefono)::jsonb;
				_datos := _datos || json_build_object('activo_nuevo', _data_new.activo)::jsonb;
				_datos := _datos || json_build_object('validado_nuevo', _data_new.validado)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('nombre_anterior', _data_old.nombre)::jsonb;
				_datos := _datos || json_build_object('apellido_anterior', _data_old.apellido)::jsonb;
				_datos := _datos || json_build_object('email_anterior', _data_old.email)::jsonb;
				_datos := _datos || json_build_object('usuario_anterior', _data_old.usuario)::jsonb;
				_datos := _datos || json_build_object('id_rol_anterior', _data_old.id_rol)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				_datos := _datos || json_build_object('contraseña_anterior', _data_old.contraseña)::jsonb;
				_datos := _datos || json_build_object('telefono_anterior', _data_old.telefono)::jsonb;
				_datos := _datos || json_build_object('activo_anterior', _data_old.activo)::jsonb;
				_datos := _datos || json_build_object('validado_anterior', _data_old.validado)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.nombre <> _data_new.nombre
				THEN _datos := _datos || json_build_object('nombre_anterior', _data_old.nombre, 'nombre_nuevo', _data_new.nombre)::jsonb;
			END IF;
			IF _data_old.apellido <> _data_new.apellido
				THEN _datos := _datos || json_build_object('apellido_anterior', _data_old.apellido, 'apellido_nuevo', _data_new.apellido)::jsonb;
			END IF;
			IF _data_old.email <> _data_new.email
				THEN _datos := _datos || json_build_object('email_anterior', _data_old.email, 'email_nuevo', _data_new.email)::jsonb;
			END IF;
			IF _data_old.usuario <> _data_new.usuario
				THEN _datos := _datos || json_build_object('usuario_anterior', _data_old.usuario, 'usuario_nuevo', _data_new.usuario)::jsonb;
			END IF;
			IF _data_old.id_rol <> _data_new.id_rol
				THEN _datos := _datos || json_build_object('id_rol_anterior', _data_old.id_rol, 'id_rol_nuevo', _data_new.id_rol)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			IF _data_old.contraseña <> _data_new.contraseña
				THEN _datos := _datos || json_build_object('contraseña_anterior', _data_old.contraseña, 'contraseña_nuevo', _data_new.contraseña)::jsonb;
			END IF;
			IF _data_old.telefono <> _data_new.telefono
				THEN _datos := _datos || json_build_object('telefono_anterior', _data_old.telefono, 'telefono_nuevo', _data_new.telefono)::jsonb;
			END IF;
			IF _data_old.activo <> _data_new.activo
				THEN _datos := _datos || json_build_object('activo_anterior', _data_old.activo, 'activo_nuevo', _data_new.activo)::jsonb;
			END IF;
			IF _data_old.validado <> _data_new.validado
				THEN _datos := _datos || json_build_object('validado_anterior', _data_old.validado, 'validado_nuevo', _data_new.validado)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'usuarios',
			'usuarios',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;
 ?   DROP FUNCTION security.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text);
       security          postgres    false    211    4    211         ?            1259    17551    PQRS_id_seq    SEQUENCE     ?   CREATE SEQUENCE publicaciones."PQRS_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE publicaciones."PQRS_id_seq";
       publicaciones          postgres    false    6    206         _           0    0    PQRS_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE publicaciones."PQRS_id_seq" OWNED BY publicaciones.pqrs.id;
          publicaciones          postgres    false    212         ?            1259    17553    historico_subastas_id_seq    SEQUENCE     ?   CREATE SEQUENCE publicaciones.historico_subastas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 7   DROP SEQUENCE publicaciones.historico_subastas_id_seq;
       publicaciones          postgres    false    6    203         `           0    0    historico_subastas_id_seq    SEQUENCE OWNED BY     e   ALTER SEQUENCE publicaciones.historico_subastas_id_seq OWNED BY publicaciones.historico_subastas.id;
          publicaciones          postgres    false    213         ?            1259    17555    inventario_id_seq    SEQUENCE     ?   CREATE SEQUENCE publicaciones.inventario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE publicaciones.inventario_id_seq;
       publicaciones          postgres    false    204    6         a           0    0    inventario_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE publicaciones.inventario_id_seq OWNED BY publicaciones.inventario.id;
          publicaciones          postgres    false    214         ?            1259    17557    piniones_id_seq    SEQUENCE     ?   CREATE SEQUENCE publicaciones.piniones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE publicaciones.piniones_id_seq;
       publicaciones          postgres    false    205    6         b           0    0    piniones_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE publicaciones.piniones_id_seq OWNED BY publicaciones.piniones.id;
          publicaciones          postgres    false    215         ?            1259    17559    subasta_id_seq    SEQUENCE     ?   CREATE SEQUENCE publicaciones.subasta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE publicaciones.subasta_id_seq;
       publicaciones          postgres    false    207    6         c           0    0    subasta_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE publicaciones.subasta_id_seq OWNED BY publicaciones.subasta.id;
          publicaciones          postgres    false    216         ?            1259    17561    talla    TABLE     ]   CREATE TABLE publicaciones.talla (
    id integer NOT NULL,
    descripcion text NOT NULL
);
     DROP TABLE publicaciones.talla;
       publicaciones         heap    postgres    false    6         ?            1259    17567    talla_id_seq    SEQUENCE     ?   CREATE SEQUENCE publicaciones.talla_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE publicaciones.talla_id_seq;
       publicaciones          postgres    false    217    6         d           0    0    talla_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE publicaciones.talla_id_seq OWNED BY publicaciones.talla.id;
          publicaciones          postgres    false    218         ?            1259    17569    tipo_bicicleta_id_seq    SEQUENCE     ?   CREATE SEQUENCE publicaciones.tipo_bicicleta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE publicaciones.tipo_bicicleta_id_seq;
       publicaciones          postgres    false    6    208         e           0    0    tipo_bicicleta_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE publicaciones.tipo_bicicleta_id_seq OWNED BY publicaciones.tipo_bicicleta.id;
          publicaciones          postgres    false    219         ?            1259    17571    tipo_frenos    TABLE     c   CREATE TABLE publicaciones.tipo_frenos (
    id integer NOT NULL,
    descripcion text NOT NULL
);
 &   DROP TABLE publicaciones.tipo_frenos;
       publicaciones         heap    postgres    false    6         ?            1259    17577    tipo_frenos_id_seq    SEQUENCE     ?   CREATE SEQUENCE publicaciones.tipo_frenos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE publicaciones.tipo_frenos_id_seq;
       publicaciones          postgres    false    220    6         f           0    0    tipo_frenos_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE publicaciones.tipo_frenos_id_seq OWNED BY publicaciones.tipo_frenos.id;
          publicaciones          postgres    false    221         ?            1259    17579 	   auditoria    TABLE     U  CREATE TABLE security.auditoria (
    id integer NOT NULL,
    fecha timestamp without time zone NOT NULL,
    accion character varying(100),
    schema character varying(200) NOT NULL,
    tabla character varying(200),
    session text NOT NULL,
    user_bd character varying(100) NOT NULL,
    data jsonb NOT NULL,
    pk text NOT NULL
);
    DROP TABLE security.auditoria;
       security         heap    postgres    false    4         g           0    0    TABLE auditoria    COMMENT     a   COMMENT ON TABLE security.auditoria IS 'Tabla que almacena la trazabilidad de la informaicón.';
          security          postgres    false    222         h           0    0    COLUMN auditoria.id    COMMENT     D   COMMENT ON COLUMN security.auditoria.id IS 'campo pk de la tabla ';
          security          postgres    false    222         i           0    0    COLUMN auditoria.fecha    COMMENT     Z   COMMENT ON COLUMN security.auditoria.fecha IS 'ALmacen ala la fecha de la modificación';
          security          postgres    false    222         j           0    0    COLUMN auditoria.accion    COMMENT     f   COMMENT ON COLUMN security.auditoria.accion IS 'Almacena la accion que se ejecuto sobre el registro';
          security          postgres    false    222         k           0    0    COLUMN auditoria.schema    COMMENT     m   COMMENT ON COLUMN security.auditoria.schema IS 'Almanena el nomnbre del schema de la tabla que se modifico';
          security          postgres    false    222         l           0    0    COLUMN auditoria.tabla    COMMENT     `   COMMENT ON COLUMN security.auditoria.tabla IS 'Almacena el nombre de la tabla que se modifico';
          security          postgres    false    222         m           0    0    COLUMN auditoria.session    COMMENT     p   COMMENT ON COLUMN security.auditoria.session IS 'Campo que almacena el id de la session que generó el cambio';
          security          postgres    false    222         n           0    0    COLUMN auditoria.user_bd    COMMENT     ?   COMMENT ON COLUMN security.auditoria.user_bd IS 'Campo que almacena el user que se autentico en el motor para generar el cmabio';
          security          postgres    false    222         o           0    0    COLUMN auditoria.data    COMMENT     d   COMMENT ON COLUMN security.auditoria.data IS 'campo que almacena la modificaicón que se realizó';
          security          postgres    false    222         p           0    0    COLUMN auditoria.pk    COMMENT     W   COMMENT ON COLUMN security.auditoria.pk IS 'Campo que identifica el id del registro.';
          security          postgres    false    222         ?            1259    17585    auditoria_id_seq    SEQUENCE     ?   CREATE SEQUENCE security.auditoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE security.auditoria_id_seq;
       security          postgres    false    4    222         q           0    0    auditoria_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE security.auditoria_id_seq OWNED BY security.auditoria.id;
          security          postgres    false    223         ?            1259    17587    function_db_view    VIEW     ?  CREATE VIEW security.function_db_view AS
 SELECT pp.proname AS b_function,
    oidvectortypes(pp.proargtypes) AS b_type_parameters
   FROM (pg_proc pp
     JOIN pg_namespace pn ON ((pn.oid = pp.pronamespace)))
  WHERE ((pn.nspname)::text <> ALL (ARRAY[('pg_catalog'::character varying)::text, ('information_schema'::character varying)::text, ('admin_control'::character varying)::text, ('vial'::character varying)::text]));
 %   DROP VIEW security.function_db_view;
       security          postgres    false    4         ?            1259    17592 
   rol_id_seq    SEQUENCE     ?   CREATE SEQUENCE usuarios.rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE usuarios.rol_id_seq;
       usuarios          postgres    false    209    8         r           0    0 
   rol_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE usuarios.rol_id_seq OWNED BY usuarios.rol.id;
          usuarios          postgres    false    225         ?            1259    17594    token_id_seq    SEQUENCE     ?   CREATE SEQUENCE usuarios.token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE usuarios.token_id_seq;
       usuarios          postgres    false    210    8         s           0    0    token_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE usuarios.token_id_seq OWNED BY usuarios.token.id;
          usuarios          postgres    false    226         ?            1259    17596    usuarios_id_seq    SEQUENCE     ?   CREATE SEQUENCE usuarios.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE usuarios.usuarios_id_seq;
       usuarios          postgres    false    8    211         t           0    0    usuarios_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE usuarios.usuarios_id_seq OWNED BY usuarios.usuarios.id;
          usuarios          postgres    false    227         ?           2604    17659    historico_subastas id    DEFAULT     ?   ALTER TABLE ONLY publicaciones.historico_subastas ALTER COLUMN id SET DEFAULT nextval('publicaciones.historico_subastas_id_seq'::regclass);
 K   ALTER TABLE publicaciones.historico_subastas ALTER COLUMN id DROP DEFAULT;
       publicaciones          postgres    false    213    203         ?           2604    17660    inventario id    DEFAULT     |   ALTER TABLE ONLY publicaciones.inventario ALTER COLUMN id SET DEFAULT nextval('publicaciones.inventario_id_seq'::regclass);
 C   ALTER TABLE publicaciones.inventario ALTER COLUMN id DROP DEFAULT;
       publicaciones          postgres    false    214    204         ?           2604    17661    piniones id    DEFAULT     x   ALTER TABLE ONLY publicaciones.piniones ALTER COLUMN id SET DEFAULT nextval('publicaciones.piniones_id_seq'::regclass);
 A   ALTER TABLE publicaciones.piniones ALTER COLUMN id DROP DEFAULT;
       publicaciones          postgres    false    215    205         ?           2604    17662    pqrs id    DEFAULT     r   ALTER TABLE ONLY publicaciones.pqrs ALTER COLUMN id SET DEFAULT nextval('publicaciones."PQRS_id_seq"'::regclass);
 =   ALTER TABLE publicaciones.pqrs ALTER COLUMN id DROP DEFAULT;
       publicaciones          postgres    false    212    206         ?           2604    17663 
   subasta id    DEFAULT     v   ALTER TABLE ONLY publicaciones.subasta ALTER COLUMN id SET DEFAULT nextval('publicaciones.subasta_id_seq'::regclass);
 @   ALTER TABLE publicaciones.subasta ALTER COLUMN id DROP DEFAULT;
       publicaciones          postgres    false    216    207         ?           2604    17664    talla id    DEFAULT     r   ALTER TABLE ONLY publicaciones.talla ALTER COLUMN id SET DEFAULT nextval('publicaciones.talla_id_seq'::regclass);
 >   ALTER TABLE publicaciones.talla ALTER COLUMN id DROP DEFAULT;
       publicaciones          postgres    false    218    217         ?           2604    17665    tipo_bicicleta id    DEFAULT     ?   ALTER TABLE ONLY publicaciones.tipo_bicicleta ALTER COLUMN id SET DEFAULT nextval('publicaciones.tipo_bicicleta_id_seq'::regclass);
 G   ALTER TABLE publicaciones.tipo_bicicleta ALTER COLUMN id DROP DEFAULT;
       publicaciones          postgres    false    219    208         ?           2604    17666    tipo_frenos id    DEFAULT     ~   ALTER TABLE ONLY publicaciones.tipo_frenos ALTER COLUMN id SET DEFAULT nextval('publicaciones.tipo_frenos_id_seq'::regclass);
 D   ALTER TABLE publicaciones.tipo_frenos ALTER COLUMN id DROP DEFAULT;
       publicaciones          postgres    false    221    220         ?           2604    17667    auditoria id    DEFAULT     p   ALTER TABLE ONLY security.auditoria ALTER COLUMN id SET DEFAULT nextval('security.auditoria_id_seq'::regclass);
 =   ALTER TABLE security.auditoria ALTER COLUMN id DROP DEFAULT;
       security          postgres    false    223    222         ?           2604    17668    rol id    DEFAULT     d   ALTER TABLE ONLY usuarios.rol ALTER COLUMN id SET DEFAULT nextval('usuarios.rol_id_seq'::regclass);
 7   ALTER TABLE usuarios.rol ALTER COLUMN id DROP DEFAULT;
       usuarios          postgres    false    225    209         ?           2604    17669    token id    DEFAULT     h   ALTER TABLE ONLY usuarios.token ALTER COLUMN id SET DEFAULT nextval('usuarios.token_id_seq'::regclass);
 9   ALTER TABLE usuarios.token ALTER COLUMN id DROP DEFAULT;
       usuarios          postgres    false    226    210         ?           2604    17670    usuarios id    DEFAULT     n   ALTER TABLE ONLY usuarios.usuarios ALTER COLUMN id SET DEFAULT nextval('usuarios.usuarios_id_seq'::regclass);
 <   ALTER TABLE usuarios.usuarios ALTER COLUMN id DROP DEFAULT;
       usuarios          postgres    false    227    211         A          0    17480    historico_subastas 
   TABLE DATA           X   COPY publicaciones.historico_subastas (id, id_comprador, id_subasta, valor) FROM stdin;
    publicaciones          postgres    false    203       3137.dat B          0    17484 
   inventario 
   TABLE DATA           ?   COPY publicaciones.inventario (id, imagen1, imagen2, imagen3, precio, status, session, modified_by, talla, referencia, marca, id_vendedor, id_comprador, fecha_revicion, color, "año", ciudad, tipo_bicicleta, tipo_frenos, "n_piñones", correo) FROM stdin;
    publicaciones          postgres    false    204       3138.dat C          0    17493    piniones 
   TABLE DATA           :   COPY publicaciones.piniones (id, descripcion) FROM stdin;
    publicaciones          postgres    false    205       3139.dat D          0    17500    pqrs 
   TABLE DATA           x   COPY publicaciones.pqrs (id, id_publicacion, id_cliente_reporto, descripcion, session, modified_by, status) FROM stdin;
    publicaciones          postgres    false    206       3140.dat E          0    17509    subasta 
   TABLE DATA           ?   COPY publicaciones.subasta (id, valor_inicial, status, puja_alta, id_producto, id_cliente, fecha_inicio, fecha_fin, modified_by, session, id_comprador, correo) FROM stdin;
    publicaciones          postgres    false    207       3141.dat O          0    17561    talla 
   TABLE DATA           7   COPY publicaciones.talla (id, descripcion) FROM stdin;
    publicaciones          postgres    false    217       3151.dat F          0    17518    tipo_bicicleta 
   TABLE DATA           @   COPY publicaciones.tipo_bicicleta (id, descripcion) FROM stdin;
    publicaciones          postgres    false    208       3142.dat R          0    17571    tipo_frenos 
   TABLE DATA           =   COPY publicaciones.tipo_frenos (id, descripcion) FROM stdin;
    publicaciones          postgres    false    220       3154.dat T          0    17579 	   auditoria 
   TABLE DATA           c   COPY security.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM stdin;
    security          postgres    false    222       3156.dat G          0    17525    rol 
   TABLE DATA           E   COPY usuarios.rol (id, desripcion, session, modified_by) FROM stdin;
    usuarios          postgres    false    209       3143.dat H          0    17534    token 
   TABLE DATA           F   COPY usuarios.token (id, finicio, ffin, tactivo, id_user) FROM stdin;
    usuarios          postgres    false    210       3144.dat I          0    17541    usuarios 
   TABLE DATA           ?   COPY usuarios.usuarios (id, nombre, apellido, email, usuario, id_rol, session, modified_by, "contraseña", telefono, activo, validado) FROM stdin;
    usuarios          postgres    false    211       3145.dat u           0    0    PQRS_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('publicaciones."PQRS_id_seq"', 5, true);
          publicaciones          postgres    false    212         v           0    0    historico_subastas_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('publicaciones.historico_subastas_id_seq', 6, true);
          publicaciones          postgres    false    213         w           0    0    inventario_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('publicaciones.inventario_id_seq', 19, true);
          publicaciones          postgres    false    214         x           0    0    piniones_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('publicaciones.piniones_id_seq', 13, true);
          publicaciones          postgres    false    215         y           0    0    subasta_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('publicaciones.subasta_id_seq', 5, true);
          publicaciones          postgres    false    216         z           0    0    talla_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('publicaciones.talla_id_seq', 5, true);
          publicaciones          postgres    false    218         {           0    0    tipo_bicicleta_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('publicaciones.tipo_bicicleta_id_seq', 8, true);
          publicaciones          postgres    false    219         |           0    0    tipo_frenos_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('publicaciones.tipo_frenos_id_seq', 3, true);
          publicaciones          postgres    false    221         }           0    0    auditoria_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('security.auditoria_id_seq', 154, true);
          security          postgres    false    223         ~           0    0 
   rol_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('usuarios.rol_id_seq', 3, true);
          usuarios          postgres    false    225                    0    0    token_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('usuarios.token_id_seq', 12, true);
          usuarios          postgres    false    226         ?           0    0    usuarios_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('usuarios.usuarios_id_seq', 5, true);
          usuarios          postgres    false    227         ?           2606    17611    pqrs PQRS_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY publicaciones.pqrs
    ADD CONSTRAINT "PQRS_pkey" PRIMARY KEY (id);
 A   ALTER TABLE ONLY publicaciones.pqrs DROP CONSTRAINT "PQRS_pkey";
       publicaciones            postgres    false    206         ?           2606    17613    piniones piniones_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY publicaciones.piniones
    ADD CONSTRAINT piniones_pkey PRIMARY KEY (id);
 G   ALTER TABLE ONLY publicaciones.piniones DROP CONSTRAINT piniones_pkey;
       publicaciones            postgres    false    205         ?           2606    17615 -   historico_subastas pk_publicaciones_historico 
   CONSTRAINT     r   ALTER TABLE ONLY publicaciones.historico_subastas
    ADD CONSTRAINT pk_publicaciones_historico PRIMARY KEY (id);
 ^   ALTER TABLE ONLY publicaciones.historico_subastas DROP CONSTRAINT pk_publicaciones_historico;
       publicaciones            postgres    false    203         ?           2606    17617 &   inventario pk_publicaciones_inventario 
   CONSTRAINT     k   ALTER TABLE ONLY publicaciones.inventario
    ADD CONSTRAINT pk_publicaciones_inventario PRIMARY KEY (id);
 W   ALTER TABLE ONLY publicaciones.inventario DROP CONSTRAINT pk_publicaciones_inventario;
       publicaciones            postgres    false    204         ?           2606    17619 .   tipo_bicicleta pk_publicaciones_tipo_bicicleta 
   CONSTRAINT     s   ALTER TABLE ONLY publicaciones.tipo_bicicleta
    ADD CONSTRAINT pk_publicaciones_tipo_bicicleta PRIMARY KEY (id);
 _   ALTER TABLE ONLY publicaciones.tipo_bicicleta DROP CONSTRAINT pk_publicaciones_tipo_bicicleta;
       publicaciones            postgres    false    208         ?           2606    17621 (   tipo_frenos pk_publicaciones_tipo_frenos 
   CONSTRAINT     m   ALTER TABLE ONLY publicaciones.tipo_frenos
    ADD CONSTRAINT pk_publicaciones_tipo_frenos PRIMARY KEY (id);
 Y   ALTER TABLE ONLY publicaciones.tipo_frenos DROP CONSTRAINT pk_publicaciones_tipo_frenos;
       publicaciones            postgres    false    220         ?           2606    17623    subasta subasta_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY publicaciones.subasta
    ADD CONSTRAINT subasta_pkey PRIMARY KEY (id);
 E   ALTER TABLE ONLY publicaciones.subasta DROP CONSTRAINT subasta_pkey;
       publicaciones            postgres    false    207         ?           2606    17625    talla talla_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY publicaciones.talla
    ADD CONSTRAINT talla_pkey PRIMARY KEY (id);
 A   ALTER TABLE ONLY publicaciones.talla DROP CONSTRAINT talla_pkey;
       publicaciones            postgres    false    217         ?           2606    17627    auditoria pk_security_auditoria 
   CONSTRAINT     _   ALTER TABLE ONLY security.auditoria
    ADD CONSTRAINT pk_security_auditoria PRIMARY KEY (id);
 K   ALTER TABLE ONLY security.auditoria DROP CONSTRAINT pk_security_auditoria;
       security            postgres    false    222         ?           2606    17629    rol rol_pkey 
   CONSTRAINT     L   ALTER TABLE ONLY usuarios.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY usuarios.rol DROP CONSTRAINT rol_pkey;
       usuarios            postgres    false    209         ?           2606    17631    token token_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY usuarios.token
    ADD CONSTRAINT token_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY usuarios.token DROP CONSTRAINT token_pkey;
       usuarios            postgres    false    210         ?           2606    17633    usuarios usuarios_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY usuarios.usuarios DROP CONSTRAINT usuarios_pkey;
       usuarios            postgres    false    211         ?           2620    17634 6   historico_subastas tg_publicaciones_historico_subastas    TRIGGER     ?   CREATE TRIGGER tg_publicaciones_historico_subastas AFTER INSERT OR DELETE OR UPDATE ON publicaciones.historico_subastas FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 V   DROP TRIGGER tg_publicaciones_historico_subastas ON publicaciones.historico_subastas;
       publicaciones          postgres    false    228    203         ?           2620    17635 &   inventario tg_publicaciones_inventario    TRIGGER     ?   CREATE TRIGGER tg_publicaciones_inventario AFTER INSERT OR DELETE OR UPDATE ON publicaciones.inventario FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 F   DROP TRIGGER tg_publicaciones_inventario ON publicaciones.inventario;
       publicaciones          postgres    false    228    204         ?           2620    17636 "   piniones tg_publicaciones_piniones    TRIGGER     ?   CREATE TRIGGER tg_publicaciones_piniones AFTER INSERT OR DELETE OR UPDATE ON publicaciones.piniones FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 B   DROP TRIGGER tg_publicaciones_piniones ON publicaciones.piniones;
       publicaciones          postgres    false    228    205         ?           2620    17637    pqrs tg_publicaciones_pqrs    TRIGGER     ?   CREATE TRIGGER tg_publicaciones_pqrs AFTER INSERT OR DELETE OR UPDATE ON publicaciones.pqrs FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 :   DROP TRIGGER tg_publicaciones_pqrs ON publicaciones.pqrs;
       publicaciones          postgres    false    228    206         ?           2620    17638     subasta tg_publicaciones_subasta    TRIGGER     ?   CREATE TRIGGER tg_publicaciones_subasta AFTER INSERT OR DELETE OR UPDATE ON publicaciones.subasta FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 @   DROP TRIGGER tg_publicaciones_subasta ON publicaciones.subasta;
       publicaciones          postgres    false    207    228         ?           2620    17639    talla tg_publicaciones_talla    TRIGGER     ?   CREATE TRIGGER tg_publicaciones_talla AFTER INSERT OR DELETE OR UPDATE ON publicaciones.talla FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 <   DROP TRIGGER tg_publicaciones_talla ON publicaciones.talla;
       publicaciones          postgres    false    217    228         ?           2620    17640 .   tipo_bicicleta tg_publicaciones_tipo_bicicleta    TRIGGER     ?   CREATE TRIGGER tg_publicaciones_tipo_bicicleta AFTER INSERT OR DELETE OR UPDATE ON publicaciones.tipo_bicicleta FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 N   DROP TRIGGER tg_publicaciones_tipo_bicicleta ON publicaciones.tipo_bicicleta;
       publicaciones          postgres    false    208    228         ?           2620    17641 (   tipo_frenos tg_publicaciones_tipo_frenos    TRIGGER     ?   CREATE TRIGGER tg_publicaciones_tipo_frenos AFTER INSERT OR DELETE OR UPDATE ON publicaciones.tipo_frenos FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 H   DROP TRIGGER tg_publicaciones_tipo_frenos ON publicaciones.tipo_frenos;
       publicaciones          postgres    false    228    220         ?           2620    17642    rol tg_usuarios_rol    TRIGGER     ?   CREATE TRIGGER tg_usuarios_rol AFTER INSERT OR DELETE OR UPDATE ON usuarios.rol FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 .   DROP TRIGGER tg_usuarios_rol ON usuarios.rol;
       usuarios          postgres    false    209    228         ?           2620    17643    token tg_usuarios_token    TRIGGER     ?   CREATE TRIGGER tg_usuarios_token AFTER INSERT OR DELETE OR UPDATE ON usuarios.token FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 2   DROP TRIGGER tg_usuarios_token ON usuarios.token;
       usuarios          postgres    false    228    210         ?           2620    17644    usuarios tg_usuarios_usuarios    TRIGGER     ?   CREATE TRIGGER tg_usuarios_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios.usuarios FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();
 8   DROP TRIGGER tg_usuarios_usuarios ON usuarios.usuarios;
       usuarios          postgres    false    211    228         ?           2606    17645 +   historico_subastas FK_publicaciones_subasta    FK CONSTRAINT     ?   ALTER TABLE ONLY publicaciones.historico_subastas
    ADD CONSTRAINT "FK_publicaciones_subasta" FOREIGN KEY (id_subasta) REFERENCES publicaciones.subasta(id);
 ^   ALTER TABLE ONLY publicaciones.historico_subastas DROP CONSTRAINT "FK_publicaciones_subasta";
       publicaciones          postgres    false    203    207    2978         ?           2606    17650 '   historico_subastas FK_usuarios_usuarios    FK CONSTRAINT     ?   ALTER TABLE ONLY publicaciones.historico_subastas
    ADD CONSTRAINT "FK_usuarios_usuarios" FOREIGN KEY (id_comprador) REFERENCES usuarios.usuarios(id);
 Z   ALTER TABLE ONLY publicaciones.historico_subastas DROP CONSTRAINT "FK_usuarios_usuarios";
       publicaciones          postgres    false    2986    211    203                                                                                                                                                                                                                                                                            3137.dat                                                                                            0000600 0004000 0002000 00000000147 14145571010 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	2	5	1500001
2	2	5	1500020
3	2	5	1500030
4	2	5	1500032
5	2	5	1500039
6	2	5	1500040
7	4	6	1000001
\.


                                                                                                                                                                                                                                                                                                                                                                                                                         3138.dat                                                                                            0000600 0004000 0002000 00000004501 14145571010 0014246 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        14	~\\publicaciones\\f4b50e1f-96da-4f00-a16f-39990a2c7e6a.jpg	~\\publicaciones\\de15b02e-5f8e-4351-bad7-30210d2cb9e0.jpg	~\\publicaciones\\e8f0ae05-bbab-4cc9-b5fb-041ca67b5ca6.jfif	1000000	2	2	16:34:47.405777	L	supercaliber	TREK	2	4	2021-10-24	#a03737	2021-10-01	bojaca	MTB	Disco Hidraulicos	12	f
18	~\\publicaciones\\557533cd-1fff-48a1-a404-d273a01a3d78.png	~\\publicaciones\\878cfdbb-7b93-4063-b137-1f3c1475b3ec.png	~\\publicaciones\\055586fe-58ae-4799-9aff-e90606925e53.jpg	15	2	2	08:38:58.146625	XL	supercaliber	TREK	2	2	2021-11-15	#ff0000	2021-11-15	bojaca	MTB	Disco Hidraulicos	11	f
13	~\\publicaciones\\2bbb17c4-473a-4c21-868e-0e7a6011eb9f.jpg	~\\publicaciones\\438833ee-570d-4ac2-8c49-8dd8948d1577.jpg	~\\publicaciones\\0ccaeb8f-7a25-4eba-ab0e-d61755441c54.jpg	1000000	3	2	22:31:43.236833	L	Hyena	GW	2	0	2021-10-25	#ffffff	2021-10-03	Bojaca	piñon fijo	Disco Hidraulicos	7	f
15	~\\publicaciones\\3f07163d-de62-41f3-954b-5733356f4180.jpg	~\\publicaciones\\170835e8-606c-4aab-b271-13276a12ead8.jpg	~\\publicaciones\\f96e04b6-b3a9-4485-a26d-74bfdb3eb63e.jfif	20000000	3	2	16:36:22.588072	L	supercaliber	TREK	2	0	2021-10-27	#fff70a	2021-10-01	bogota	MTB	Disco Hidraulicos	7	f
16	~\\publicaciones\\a07b02fa-1afd-43c0-958d-f02fd508991f.jfif	~\\publicaciones\\cc706795-39a0-4dd5-9afe-aed1ccf07644.jpg	~\\publicaciones\\4036de97-5c44-4ecf-93c1-b4f7345c49fa.jpg	3000000	3	2	16:42:33.210662	XL	supercaliber	TREK	2	0	2021-10-25	#11ff00	2021-10-24	bogota	MTB	Disco Hidraulicos	10	f
17	~\\publicaciones\\cca5fed0-b50a-4cb7-8217-58bbb4724811.png	~\\publicaciones\\12e4131b-7e97-4a16-be02-9128d109f123.png	~\\publicaciones\\d33febbe-6367-43ef-9dd3-d6f38ba7ba1a.jpg	50000	3	5	08:10:00.542522	XL	muy bonita	SPECIALIZED	5	0	2021-12-22	#3aee46	2022-01-01	faca	Ruta	Disco  guaya	6	f
19	~\\publicaciones\\9a44f5a5-d005-430a-b410-57c71bd5ca7e.jpg	~\\publicaciones\\dc16c7ba-e532-4abd-9bba-a755178fb11d.jpg	~\\publicaciones\\065be45a-a393-4724-bd2e-2a89576fc544.jpg	1500000	3	2	01:17:57.056433	S	trail sl3	Cannondale	2	0	2021-11-15	#ffffff	2014-07-28	bojaca	MTB	Disco Hidraulicos	6	f
12	~\\publicaciones\\7923504b-6b55-40cf-8910-3233ad22ccce.jpg	~\\publicaciones\\8e156ba3-1dcf-4392-9f09-c61a185018ba.jpg	~\\publicaciones\\6ef3d9a8-b27f-499e-8d2f-9f6c98b7a1ff.jpg	1000000	3	2	22:25:17.965424	XL	Zebra	GW	2	2	2021-10-17	#ff0000	2021-10-24	Bojaca	piñon fijo	Disco Hidraulicos	7	f
\.


                                                                                                                                                                                               3139.dat                                                                                            0000600 0004000 0002000 00000000133 14145571010 0014244 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1
2	6
3	7
4	mega 7
5	8
6	mega 8
7	9
8	mega 9
9	10
10	11
11	mega 11
12	12
13	mega 12
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                     3140.dat                                                                                            0000600 0004000 0002000 00000000224 14145571010 0014235 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        3	19	4	la publicación no corresponde a las imágenes insertadas	4	2021-11-17 01:21:00.424345	0
5	19	2	ta linda	2	2021-11-18 11:50:14.385221	0
\.


                                                                                                                                                                                                                                                                                                                                                                            3141.dat                                                                                            0000600 0004000 0002000 00000001205 14145571010 0014236 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        5	1500000	1	1500040	19	2	2021-11-18 12:11:00.86782	2021-11-19 12:11:00.86782	2021-11-18 12:11:00.880995	2	2	f
1	1000000	2	1000000	13	2	2021-11-13 00:00:00	2021-11-14 00:00:00	2021-11-13 09:22:28.826237	2	1	t
2	3000000	3	3000000	16	2	2021-11-13 00:00:00	2021-11-13 00:00:00	2021-11-13 10:00:33.635754	2	0	t
3	20000000	3	20000000	15	2	2021-11-13 10:18:45.307527	2021-11-13 10:19:45.307527	2021-11-13 10:18:45.310413	2	0	t
4	50000	3	50000	17	5	2021-11-16 08:10:42.681388	2021-11-16 08:11:42.681388	2021-11-16 08:10:42.693984	5	0	t
6	1000000	2	1000001	12	2	2021-11-18 17:51:03.719311	2021-11-18 17:53:03.719311	2021-11-18 17:51:03.729838	2	4	t
\.


                                                                                                                                                                                                                                                                                                                                                                                           3151.dat                                                                                            0000600 0004000 0002000 00000000035 14145571010 0014237 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	XS\n
2	S
3	M
4	L
5	XL
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   3142.dat                                                                                            0000600 0004000 0002000 00000000060 14145571010 0014235 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	MTB\n
2	Ruta
3	Pista
4	Piñon fijo
5	BMX
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                3154.dat                                                                                            0000600 0004000 0002000 00000000062 14145571010 0014242 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Disco Hidraulicos
2	Disco  guaya
3	zapata 
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                              3156.dat                                                                                            0000600 0004000 0002000 00000103456 14145571010 0014257 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        41	2021-10-27 15:26:07.95925	UPDATE	usuarios	usuarios	web	postgres	{"contraseña_nuevo": "cQB3AGUAMQAyADMAYQBzAA==", "contraseña_anterior": "ZQBzAHQAbABlAG8AbgA="}	2
42	2021-10-27 15:53:13.759744	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 7, "año_nuevo": "2020-01-01", "color_nuevo": "#000000", "marca_nuevo": "GW", "talla_nuevo": null, "ciudad_nuevo": "Bojaca", "precio_nuevo": 1000000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\e49940fb-a936-402e-97ef-c5233f3cbd0c.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\7c30095f-0f90-4d54-a2e6-ff51934107f0.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\e7a6f52f-54c8-4e2f-94fb-ada34f0708c6.jpg", "imagen4_nuevo": null, "imagen5_nuevo": null, "session_nuevo": "2", "n_piñones_nuevo": 8, "referencia_nuevo": "Hyena", "id_vendedor_nuevo": 2, "modified_by_nuevo": "15:53:13.759744", "tipo_frenos_nuevo": 1, "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-25", "tipo_bicicleta_nuevo": 1}	7
43	2021-10-27 18:44:19.150602	DELETE	publicaciones	inventario	2	postgres	{"id_anterior": 7, "año_anterior": "2020-01-01", "color_anterior": "#000000", "marca_anterior": "GW", "talla_anterior": null, "ciudad_anterior": "Bojaca", "precio_anterior": 1000000, "status_anterior": 1, "imagen1_anterior": "~\\\\publicaciones\\\\e49940fb-a936-402e-97ef-c5233f3cbd0c.jpg", "imagen2_anterior": "~\\\\publicaciones\\\\7c30095f-0f90-4d54-a2e6-ff51934107f0.jpg", "imagen3_anterior": "~\\\\publicaciones\\\\e7a6f52f-54c8-4e2f-94fb-ada34f0708c6.jpg", "imagen4_anterior": null, "imagen5_anterior": null, "session_anterior": "2", "n_piñones_anterior": 8, "referencia_anterior": "Hyena", "id_vendedor_anterior": 2, "modified_by_anterior": "15:53:13.759744", "tipo_frenos_anterior": 1, "id_comprador_anterior": 0, "fecha_revicion_anterior": "2021-10-25", "tipo_bicicleta_anterior": 1}	7
44	2021-10-27 19:48:24.134166	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 8, "año_nuevo": "2021-10-05", "color_nuevo": "#067462", "marca_nuevo": "GW", "talla_nuevo": null, "ciudad_nuevo": "Bojaca", "precio_nuevo": 1000000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\7e32a4f7-4449-4bf2-a06f-bf902efad189.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\87465dfb-93ac-4ac4-ae6f-7f384568d23e.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\cbce0317-ddce-4ebe-ad1d-f02900e11f70.jpg", "imagen4_nuevo": null, "imagen5_nuevo": null, "session_nuevo": "2", "n_piñones_nuevo": 9, "referencia_nuevo": "Hyena", "id_vendedor_nuevo": 2, "modified_by_nuevo": "19:48:24.134166", "tipo_frenos_nuevo": "1", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-24", "tipo_bicicleta_nuevo": "1"}	8
45	2021-10-27 19:54:24.763535	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 9, "año_nuevo": "2021-10-01", "color_nuevo": "#b72424", "marca_nuevo": "GW", "talla_nuevo": "M", "ciudad_nuevo": "Bojaca", "precio_nuevo": 3000000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\656e8587-25b3-451a-871f-3f52d490f3ab.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\f37bf2e9-2783-48fe-8e98-1e5c0863f192.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\888aa76b-1eb3-49ee-8e8c-48419f9e8897.jpg", "imagen4_nuevo": null, "imagen5_nuevo": null, "session_nuevo": "2", "n_piñones_nuevo": 9, "referencia_nuevo": "Scorpion", "id_vendedor_nuevo": 2, "modified_by_nuevo": "19:54:24.763535", "tipo_frenos_nuevo": "1", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-11", "tipo_bicicleta_nuevo": "1"}	9
46	2021-10-27 19:58:05.155318	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 10, "año_nuevo": "2021-10-02", "color_nuevo": "#d20404", "marca_nuevo": "GW", "talla_nuevo": "L", "ciudad_nuevo": "Bojaca", "precio_nuevo": 2000000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\c33b7de8-18bb-44eb-a0ea-5ebd702cba82.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\e89864d8-6077-4bbc-b47e-7dbb9122800a.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\87ee04d0-0acd-4e72-8c12-71d9b9378ba0.jpg", "imagen4_nuevo": null, "imagen5_nuevo": null, "session_nuevo": "2", "n_piñones_nuevo": 9, "referencia_nuevo": "Hyena", "id_vendedor_nuevo": 2, "modified_by_nuevo": "19:58:05.155318", "tipo_frenos_nuevo": "2", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-11", "tipo_bicicleta_nuevo": "3"}	10
47	2021-10-27 20:04:05.795917	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 11, "año_nuevo": "2021-10-01", "color_nuevo": "#37ff00", "marca_nuevo": "GW", "talla_nuevo": "L", "ciudad_nuevo": "Bojaca", "precio_nuevo": 123456, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\badfb31b-d758-4643-a33f-ea36fa77d514.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\a6467e6b-8a1e-4ad7-a0bb-4fdcb17162a9.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\fb6e6e2e-d90c-4790-a371-112f6e6b3d4c.jpg", "imagen4_nuevo": null, "imagen5_nuevo": null, "session_nuevo": "2", "n_piñones_nuevo": 8, "referencia_nuevo": "Scorpion", "id_vendedor_nuevo": 2, "modified_by_nuevo": "20:04:05.795917", "tipo_frenos_nuevo": "Frenos de zapata de gualla", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-25", "tipo_bicicleta_nuevo": "Ruta"}	11
48	2021-10-27 20:10:06.472034	UPDATE	publicaciones	inventario	2	postgres	{}	8
49	2021-10-27 20:10:06.472034	UPDATE	publicaciones	inventario	2	postgres	{"tipo_frenos_nuevo": "Frenos de zapata", "tipo_frenos_anterior": "Frenos de zapata de gualla"}	11
50	2021-10-27 22:08:27.227346	DELETE	publicaciones	inventario	2	postgres	{"id_anterior": 9, "año_anterior": "2021-10-01", "color_anterior": "#b72424", "marca_anterior": "GW", "talla_anterior": "M", "ciudad_anterior": "Bojaca", "precio_anterior": 3000000, "status_anterior": 1, "imagen1_anterior": "~\\\\publicaciones\\\\656e8587-25b3-451a-871f-3f52d490f3ab.jpg", "imagen2_anterior": "~\\\\publicaciones\\\\f37bf2e9-2783-48fe-8e98-1e5c0863f192.jpg", "imagen3_anterior": "~\\\\publicaciones\\\\888aa76b-1eb3-49ee-8e8c-48419f9e8897.jpg", "session_anterior": "2", "n_piñones_anterior": 9, "referencia_anterior": "Scorpion", "id_vendedor_anterior": 2, "modified_by_anterior": "19:54:24.763535", "tipo_frenos_anterior": "1", "id_comprador_anterior": 0, "fecha_revicion_anterior": "2021-10-11", "tipo_bicicleta_anterior": "1"}	9
51	2021-10-27 22:08:27.227346	DELETE	publicaciones	inventario	2	postgres	{"id_anterior": 10, "año_anterior": "2021-10-02", "color_anterior": "#d20404", "marca_anterior": "GW", "talla_anterior": "L", "ciudad_anterior": "Bojaca", "precio_anterior": 2000000, "status_anterior": 1, "imagen1_anterior": "~\\\\publicaciones\\\\c33b7de8-18bb-44eb-a0ea-5ebd702cba82.jpg", "imagen2_anterior": "~\\\\publicaciones\\\\e89864d8-6077-4bbc-b47e-7dbb9122800a.jpg", "imagen3_anterior": "~\\\\publicaciones\\\\87ee04d0-0acd-4e72-8c12-71d9b9378ba0.jpg", "session_anterior": "2", "n_piñones_anterior": 9, "referencia_anterior": "Hyena", "id_vendedor_anterior": 2, "modified_by_anterior": "19:58:05.155318", "tipo_frenos_anterior": "2", "id_comprador_anterior": 0, "fecha_revicion_anterior": "2021-10-11", "tipo_bicicleta_anterior": "3"}	10
66	2021-11-13 10:18:45.310413	INSERT	publicaciones	subasta	2	postgres	{"id_nuevo": 3, "status_nuevo": 1, "session_nuevo": "2", "fecha_fin_nuevo": "2021-11-13T10:19:45.307527", "puja_alta_nuevo": 20000000, "id_cliente_nuevo": 2, "id_producto_nuevo": 15, "modified_by_nuevo": "2021-11-13T10:18:45.310413", "fecha_inicio_nuevo": "2021-11-13T10:18:45.307527", "id_comprador_nuevo": null, "valor_inicial_nuevo": 20000000}	3
52	2021-10-27 22:08:27.227346	DELETE	publicaciones	inventario	2	postgres	{"id_anterior": 8, "año_anterior": "2021-10-05", "color_anterior": "#067462", "marca_anterior": "GW", "talla_anterior": "S", "ciudad_anterior": "Bojaca", "precio_anterior": 1000000, "status_anterior": 1, "imagen1_anterior": "~\\\\publicaciones\\\\7e32a4f7-4449-4bf2-a06f-bf902efad189.jpg", "imagen2_anterior": "~\\\\publicaciones\\\\87465dfb-93ac-4ac4-ae6f-7f384568d23e.jpg", "imagen3_anterior": "~\\\\publicaciones\\\\cbce0317-ddce-4ebe-ad1d-f02900e11f70.jpg", "session_anterior": "2", "n_piñones_anterior": 9, "referencia_anterior": "Hyena", "id_vendedor_anterior": 2, "modified_by_anterior": "19:48:24.134166", "tipo_frenos_anterior": "1", "id_comprador_anterior": 0, "fecha_revicion_anterior": "2021-10-24", "tipo_bicicleta_anterior": "1"}	8
53	2021-10-27 22:08:27.227346	DELETE	publicaciones	inventario	2	postgres	{"id_anterior": 11, "año_anterior": "2021-10-01", "color_anterior": "#37ff00", "marca_anterior": "GW", "talla_anterior": "L", "ciudad_anterior": "Bojaca", "precio_anterior": 123456, "status_anterior": 1, "imagen1_anterior": "~\\\\publicaciones\\\\badfb31b-d758-4643-a33f-ea36fa77d514.jpg", "imagen2_anterior": "~\\\\publicaciones\\\\a6467e6b-8a1e-4ad7-a0bb-4fdcb17162a9.jpg", "imagen3_anterior": "~\\\\publicaciones\\\\fb6e6e2e-d90c-4790-a371-112f6e6b3d4c.jpg", "session_anterior": "2", "n_piñones_anterior": 8, "referencia_anterior": "Scorpion", "id_vendedor_anterior": 2, "modified_by_anterior": "20:04:05.795917", "tipo_frenos_anterior": "Frenos de zapata", "id_comprador_anterior": 0, "fecha_revicion_anterior": "2021-10-25", "tipo_bicicleta_anterior": "Ruta"}	11
54	2021-10-27 22:25:17.965424	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 12, "año_nuevo": "2021-10-24", "color_nuevo": "#ff0000", "marca_nuevo": "GW", "talla_nuevo": "XL", "ciudad_nuevo": "Bojaca", "precio_nuevo": 1000000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\7923504b-6b55-40cf-8910-3233ad22ccce.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\8e156ba3-1dcf-4392-9f09-c61a185018ba.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\6ef3d9a8-b27f-499e-8d2f-9f6c98b7a1ff.jpg", "session_nuevo": "2", "n_piñones_nuevo": 9, "referencia_nuevo": "Zebra", "id_vendedor_nuevo": 2, "modified_by_nuevo": "22:25:17.965424", "tipo_frenos_nuevo": "Disco Hidraulicos", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-17", "tipo_bicicleta_nuevo": "piñon fijo"}	12
55	2021-10-27 22:31:43.236833	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 13, "año_nuevo": "2021-10-03", "color_nuevo": "#ffffff", "marca_nuevo": "GW", "talla_nuevo": "L", "ciudad_nuevo": "Bojaca", "precio_nuevo": 1000000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\2bbb17c4-473a-4c21-868e-0e7a6011eb9f.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\438833ee-570d-4ac2-8c49-8dd8948d1577.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\0ccaeb8f-7a25-4eba-ab0e-d61755441c54.jpg", "session_nuevo": "2", "n_piñones_nuevo": 9, "referencia_nuevo": "Hyena", "id_vendedor_nuevo": 2, "modified_by_nuevo": "22:31:43.236833", "tipo_frenos_nuevo": "Disco Hidraulicos", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-25", "tipo_bicicleta_nuevo": "piñon fijo"}	13
56	2021-10-28 16:34:47.405777	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 14, "año_nuevo": "2021-10-01", "color_nuevo": "#a03737", "marca_nuevo": "TREK", "talla_nuevo": "L", "ciudad_nuevo": "bojaca", "precio_nuevo": 1000000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\f4b50e1f-96da-4f00-a16f-39990a2c7e6a.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\de15b02e-5f8e-4351-bad7-30210d2cb9e0.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\e8f0ae05-bbab-4cc9-b5fb-041ca67b5ca6.jfif", "session_nuevo": "2", "n_piñones_nuevo": 12, "referencia_nuevo": "supercaliber", "id_vendedor_nuevo": 2, "modified_by_nuevo": "16:34:47.405777", "tipo_frenos_nuevo": "Disco Hidraulicos", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-24", "tipo_bicicleta_nuevo": "Seleccione"}	14
57	2021-10-28 16:36:22.588072	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 15, "año_nuevo": "2021-10-01", "color_nuevo": "#fff70a", "marca_nuevo": "TREK", "talla_nuevo": "L", "ciudad_nuevo": "bogota", "precio_nuevo": 20000000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\3f07163d-de62-41f3-954b-5733356f4180.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\170835e8-606c-4aab-b271-13276a12ead8.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\f96e04b6-b3a9-4485-a26d-74bfdb3eb63e.jfif", "session_nuevo": "2", "n_piñones_nuevo": 12, "referencia_nuevo": "supercaliber", "id_vendedor_nuevo": 2, "modified_by_nuevo": "16:36:22.588072", "tipo_frenos_nuevo": "Disco Hidraulicos", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-27", "tipo_bicicleta_nuevo": "Seleccione"}	15
58	2021-10-28 16:42:33.210662	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 16, "año_nuevo": "2021-10-24", "color_nuevo": "#11ff00", "marca_nuevo": "TREK", "talla_nuevo": "XL", "ciudad_nuevo": "bogota", "precio_nuevo": 3000000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\a07b02fa-1afd-43c0-958d-f02fd508991f.jfif", "imagen2_nuevo": "~\\\\publicaciones\\\\cc706795-39a0-4dd5-9afe-aed1ccf07644.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\4036de97-5c44-4ecf-93c1-b4f7345c49fa.jpg", "session_nuevo": "2", "n_piñones_nuevo": 12, "referencia_nuevo": "supercaliber", "id_vendedor_nuevo": 2, "modified_by_nuevo": "16:42:33.210662", "tipo_frenos_nuevo": "Disco Hidraulicos", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-10-25", "tipo_bicicleta_nuevo": "Seleccione"}	16
59	2021-10-28 16:45:00.375528	INSERT	usuarios	usuarios	web	postgres	{"id_nuevo": 4, "email_nuevo": "eysonesteban1998@gmail.com", "activo_nuevo": 1, "id_rol_nuevo": 3, "nombre_nuevo": "pedro", "session_nuevo": "web", "usuario_nuevo": "pedro", "apellido_nuevo": "picapiedra", "telefono_nuevo": "3138582047", "contraseña_nuevo": "cQB3AGUAYQBzAGQAegB4AGMA", "modified_by_nuevo": "16:45:00.375528"}	4
60	2021-11-13 09:22:28.287504	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	13
61	2021-11-13 09:22:28.826237	INSERT	publicaciones	subasta	2	postgres	{"id_nuevo": 1, "status_nuevo": 1, "session_nuevo": "2", "fecha_fin_nuevo": "2021-11-14", "puja_alta_nuevo": 1000000, "id_cliente_nuevo": 2, "id_producto_nuevo": 13, "modified_by_nuevo": "2021-11-13T09:22:28.826237", "fecha_inicio_nuevo": "2021-11-13", "id_comprador_nuevo": null, "valor_inicial_nuevo": 1000000}	1
62	2021-11-13 10:00:33.556002	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	16
63	2021-11-13 10:00:33.635754	INSERT	publicaciones	subasta	2	postgres	{"id_nuevo": 2, "status_nuevo": 1, "session_nuevo": "2", "fecha_fin_nuevo": "2021-11-13", "puja_alta_nuevo": 3000000, "id_cliente_nuevo": 2, "id_producto_nuevo": 16, "modified_by_nuevo": "2021-11-13T10:00:33.635754", "fecha_inicio_nuevo": "2021-11-13", "id_comprador_nuevo": null, "valor_inicial_nuevo": 3000000}	2
64	2021-11-13 10:15:21.723757	UPDATE	publicaciones	subasta	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	2
65	2021-11-13 10:18:45.264443	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	15
67	2021-11-13 10:20:02.324343	UPDATE	publicaciones	subasta	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	3
68	2021-11-13 23:37:05.949402	UPDATE	usuarios	usuarios	1	postgres	{"session_nuevo": "1", "session_anterior": "web", "contraseña_nuevo": "KgAqACoAKgAqACoAKgAqAA==", "contraseña_anterior": "cQB3AGUAMQAyADMAYQBzAA=="}	1
69	2021-11-13 23:42:33.584602	UPDATE	usuarios	usuarios	web	postgres	{"id_rol_nuevo": 1, "id_rol_anterior": 3}	4
70	2021-11-13 23:47:22.297487	UPDATE	usuarios	usuarios	1	postgres	{"contraseña_nuevo": "cQB3AGUAMQAyADMAYQBzAA==", "contraseña_anterior": "KgAqACoAKgAqACoAKgAqAA=="}	1
71	2021-11-13 23:47:49.642237	UPDATE	usuarios	usuarios	web	postgres	{"contraseña_nuevo": "cQB3AGUAMQAyADMAYQBzAA==", "contraseña_anterior": "cQB3AGUAYQBzAGQAegB4AGMA"}	4
72	2021-11-13 23:47:57.463051	UPDATE	usuarios	usuarios	web	postgres	{"id_rol_nuevo": 3, "id_rol_anterior": 1}	4
73	2021-11-13 23:48:15.06595	UPDATE	usuarios	usuarios	web	postgres	{"email_nuevo": "bojacasa@gmail.com", "email_anterior": "eysonesteban1998@gmail.com"}	4
74	2021-11-13 23:49:48.584238	UPDATE	usuarios	usuarios	4	postgres	{"session_nuevo": "4", "session_anterior": "web", "contraseña_nuevo": "KgAqACoAKgAqACoAKgAqAA==", "contraseña_anterior": "cQB3AGUAMQAyADMAYQBzAA=="}	4
75	2021-11-13 23:53:38.730784	UPDATE	usuarios	usuarios	4	postgres	{}	4
76	2021-11-13 23:57:16.16307	UPDATE	usuarios	usuarios	4	postgres	{}	4
77	2021-11-14 00:00:01.015349	UPDATE	publicaciones	subasta	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	1
78	2021-11-14 00:02:02.032861	UPDATE	usuarios	usuarios	4	postgres	{}	4
79	2021-11-14 00:04:05.828261	UPDATE	usuarios	usuarios	4	postgres	{"contraseña_nuevo": "", "contraseña_anterior": "KgAqACoAKgAqACoAKgAqAA=="}	4
80	2021-11-14 00:04:23.932128	UPDATE	usuarios	usuarios	4	postgres	{"contraseña_nuevo": "cQB3AGUAMQAyADMAYQBzAA==", "contraseña_anterior": ""}	4
81	2021-11-14 00:15:08.345908	UPDATE	usuarios	usuarios	4	postgres	{}	4
82	2021-11-14 00:23:12.282037	UPDATE	usuarios	usuarios	4	postgres	{"nombre_nuevo": "pedro armando", "apellido_nuevo": "picapiedra castillo", "nombre_anterior": "pedro", "apellido_anterior": "picapiedra"}	4
83	2021-11-14 00:27:31.806678	UPDATE	usuarios	usuarios	4	postgres	{"nombre_nuevo": "pedro", "apellido_nuevo": "picapiedra", "nombre_anterior": "pedro armando", "apellido_anterior": "picapiedra castillo"}	4
84	2021-11-14 01:55:10.238298	UPDATE	usuarios	usuarios	4	postgres	{"telefono_nuevo": "3112794086", "telefono_anterior": "3138582047"}	4
85	2021-11-14 02:18:25.599322	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 2, "status_anterior": 1, "id_comprador_nuevo": 4, "id_comprador_anterior": 0}	14
86	2021-11-16 08:02:59.229987	INSERT	usuarios	usuarios	web	postgres	{"id_nuevo": 5, "email_nuevo": "mongee1@gmail.com", "activo_nuevo": 1, "id_rol_nuevo": 3, "nombre_nuevo": "prueba", "session_nuevo": "web", "usuario_nuevo": "prueba", "apellido_nuevo": "prueba", "telefono_nuevo": "3124583735", "contraseña_nuevo": "cAByAHUAZQBiAGEA", "modified_by_nuevo": "08:02:59.229987"}	5
87	2021-11-16 08:10:00.542522	INSERT	publicaciones	inventario	5	postgres	{"id_nuevo": 17, "año_nuevo": "2022-01-01", "color_nuevo": "#3aee46", "marca_nuevo": "SPECIALIZED", "talla_nuevo": "XL", "ciudad_nuevo": "faca", "precio_nuevo": 50000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\cca5fed0-b50a-4cb7-8217-58bbb4724811.png", "imagen2_nuevo": "~\\\\publicaciones\\\\12e4131b-7e97-4a16-be02-9128d109f123.png", "imagen3_nuevo": "~\\\\publicaciones\\\\d33febbe-6367-43ef-9dd3-d6f38ba7ba1a.jpg", "session_nuevo": "5", "n_piñones_nuevo": 1000, "referencia_nuevo": "muy bonita", "id_vendedor_nuevo": 5, "modified_by_nuevo": "08:10:00.542522", "tipo_frenos_nuevo": "Disco  guaya", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-12-22", "tipo_bicicleta_nuevo": "Ruta"}	17
88	2021-11-16 08:10:42.622759	UPDATE	publicaciones	inventario	5	postgres	{"status_nuevo": 3, "status_anterior": 1}	17
89	2021-11-16 08:10:42.693984	INSERT	publicaciones	subasta	5	postgres	{"id_nuevo": 4, "status_nuevo": 1, "session_nuevo": "5", "fecha_fin_nuevo": "2021-11-16T08:11:42.681388", "puja_alta_nuevo": 50000, "id_cliente_nuevo": 5, "id_producto_nuevo": 17, "modified_by_nuevo": "2021-11-16T08:10:42.693984", "fecha_inicio_nuevo": "2021-11-16T08:10:42.681388", "id_comprador_nuevo": null, "valor_inicial_nuevo": 50000}	4
90	2021-11-16 08:15:01.889342	UPDATE	publicaciones	subasta	5	postgres	{"status_nuevo": 3, "status_anterior": 1}	4
91	2021-11-16 08:25:00.4648	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 2, "status_anterior": 1, "id_comprador_nuevo": 2, "id_comprador_anterior": 0}	12
92	2021-11-16 08:38:58.146625	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 18, "año_nuevo": "2021-11-15", "color_nuevo": "#ff0000", "marca_nuevo": "TREK", "talla_nuevo": "Seleccione", "ciudad_nuevo": "bojaca", "precio_nuevo": 15, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\557533cd-1fff-48a1-a404-d273a01a3d78.png", "imagen2_nuevo": "~\\\\publicaciones\\\\878cfdbb-7b93-4063-b137-1f3c1475b3ec.png", "imagen3_nuevo": "~\\\\publicaciones\\\\055586fe-58ae-4799-9aff-e90606925e53.jpg", "session_nuevo": "2", "n_piñones_nuevo": 10, "referencia_nuevo": "supercaliber", "id_vendedor_nuevo": 2, "modified_by_nuevo": "08:38:58.146625", "tipo_frenos_nuevo": "Disco Hidraulicos", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-11-15", "tipo_bicicleta_nuevo": "Seleccione"}	18
93	2021-11-16 08:41:02.005794	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 2, "status_anterior": 1, "id_comprador_nuevo": 2, "id_comprador_anterior": 0}	18
94	2021-11-16 08:46:33.508968	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 1, "status_anterior": 2}	18
95	2021-11-16 08:48:11.313948	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 2, "status_anterior": 1}	18
96	2021-11-17 01:17:57.056433	INSERT	publicaciones	inventario	2	postgres	{"id_nuevo": 19, "año_nuevo": "2014-07-28", "color_nuevo": "#ffffff", "marca_nuevo": "Cannondale", "talla_nuevo": "S", "ciudad_nuevo": "bojaca", "precio_nuevo": 1500000, "status_nuevo": 1, "imagen1_nuevo": "~\\\\publicaciones\\\\9a44f5a5-d005-430a-b410-57c71bd5ca7e.jpg", "imagen2_nuevo": "~\\\\publicaciones\\\\dc16c7ba-e532-4abd-9bba-a755178fb11d.jpg", "imagen3_nuevo": "~\\\\publicaciones\\\\065be45a-a393-4724-bd2e-2a89576fc544.jpg", "session_nuevo": "2", "n_piñones_nuevo": 9, "referencia_nuevo": "trail sl3", "id_vendedor_nuevo": 2, "modified_by_nuevo": "01:17:57.056433", "tipo_frenos_nuevo": "Disco Hidraulicos", "id_comprador_nuevo": 0, "fecha_revicion_nuevo": "2021-11-15", "tipo_bicicleta_nuevo": "Seleccione"}	19
97	2021-11-18 11:43:47.033828	UPDATE	publicaciones	subasta	2	postgres	{"status_nuevo": 1, "status_anterior": 3}	1
98	2021-11-18 11:43:47.033828	UPDATE	publicaciones	subasta	2	postgres	{"status_nuevo": 1, "status_anterior": 3}	3
99	2021-11-18 11:50:14.385221	INSERT	publicaciones	pqrs	2	postgres	{"id_nuevo": 5, "status_nuevo": 0, "session_nuevo": "2", "descripcion_nuevo": "ta linda", "modified_by_nuevo": "2021-11-18T11:50:14.385221", "id_publicacion_nuevo": 19, "id_cliente_reporto_nuevo": 2}	5
100	2021-11-18 11:55:34.236813	UPDATE	usuarios	usuarios	1	postgres	{}	1
101	2021-11-18 11:55:34.236813	UPDATE	usuarios	usuarios	web	postgres	{}	2
102	2021-11-18 11:55:34.236813	UPDATE	usuarios	usuarios	web	postgres	{}	3
103	2021-11-18 11:55:34.236813	UPDATE	usuarios	usuarios	4	postgres	{}	4
104	2021-11-18 11:55:34.236813	UPDATE	usuarios	usuarios	web	postgres	{}	5
105	2021-11-18 11:58:30.082868	UPDATE	publicaciones	tipo_bicicleta		postgres	{"descripcion_nuevo": "Piñon fijo", "descripcion_anterior": "piñon fijo"}	4
106	2021-11-18 12:11:00.770552	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	19
107	2021-11-18 12:11:00.880995	INSERT	publicaciones	subasta	2	postgres	{"id_nuevo": 5, "status_nuevo": 1, "session_nuevo": "2", "fecha_fin_nuevo": "2021-11-19T12:11:00.86782", "puja_alta_nuevo": 1500000, "id_cliente_nuevo": 2, "id_producto_nuevo": 19, "modified_by_nuevo": "2021-11-18T12:11:00.880995", "fecha_inicio_nuevo": "2021-11-18T12:11:00.86782", "id_comprador_nuevo": null, "valor_inicial_nuevo": 1500000}	5
108	2021-11-18 12:11:32.59301	INSERT	publicaciones	historico_subastas		postgres	{"id_nuevo": 1, "valor_nuevo": 1500001, "id_subasta_nuevo": 5, "id_comprador_nuevo": 2}	1
109	2021-11-18 12:11:32.615167	UPDATE	publicaciones	subasta	2	postgres	{"puja_alta_nuevo": 1500001, "puja_alta_anterior": 1500000}	5
110	2021-11-18 12:12:40.665789	INSERT	publicaciones	historico_subastas		postgres	{"id_nuevo": 2, "valor_nuevo": 1500020, "id_subasta_nuevo": 5, "id_comprador_nuevo": 2}	2
111	2021-11-18 12:12:40.818807	UPDATE	publicaciones	subasta	2	postgres	{"puja_alta_nuevo": 1500020, "puja_alta_anterior": 1500001}	5
112	2021-11-18 12:13:36.52538	INSERT	publicaciones	historico_subastas		postgres	{"id_nuevo": 3, "valor_nuevo": 1500030, "id_subasta_nuevo": 5, "id_comprador_nuevo": 2}	3
113	2021-11-18 12:13:36.543725	UPDATE	publicaciones	subasta	2	postgres	{"puja_alta_nuevo": 1500030, "puja_alta_anterior": 1500020}	5
114	2021-11-18 12:16:30.805908	INSERT	publicaciones	historico_subastas		postgres	{"id_nuevo": 4, "valor_nuevo": 1500032, "id_subasta_nuevo": 5, "id_comprador_nuevo": 2}	4
115	2021-11-18 12:16:30.878945	UPDATE	publicaciones	subasta	2	postgres	{"puja_alta_nuevo": 1500032, "puja_alta_anterior": 1500030}	5
116	2021-11-18 12:17:46.781228	INSERT	publicaciones	historico_subastas		postgres	{"id_nuevo": 5, "valor_nuevo": 1500039, "id_subasta_nuevo": 5, "id_comprador_nuevo": 2}	5
117	2021-11-18 12:17:46.798136	UPDATE	publicaciones	subasta	2	postgres	{"puja_alta_nuevo": 1500039, "puja_alta_anterior": 1500032}	5
118	2021-11-18 12:20:09.61999	INSERT	publicaciones	historico_subastas		postgres	{"id_nuevo": 6, "valor_nuevo": 1500040, "id_subasta_nuevo": 5, "id_comprador_nuevo": 2}	6
119	2021-11-18 12:20:09.63785	UPDATE	publicaciones	subasta	2	postgres	{"puja_alta_nuevo": 1500040, "puja_alta_anterior": 1500039}	5
120	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 1, "descripcion_nuevo": "1"}	1
121	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 2, "descripcion_nuevo": "6"}	2
122	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 3, "descripcion_nuevo": "7"}	3
123	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 4, "descripcion_nuevo": "mega 7"}	4
124	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 5, "descripcion_nuevo": "8"}	5
125	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 6, "descripcion_nuevo": "mega 8"}	6
126	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 7, "descripcion_nuevo": "9"}	7
127	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 8, "descripcion_nuevo": "mega 9"}	8
128	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 9, "descripcion_nuevo": "10"}	9
129	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 10, "descripcion_nuevo": "11"}	10
130	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 11, "descripcion_nuevo": "mega 11"}	11
131	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 12, "descripcion_nuevo": "12"}	12
132	2021-11-18 12:44:03.895915	INSERT	publicaciones	piniones		postgres	{"id_nuevo": 13, "descripcion_nuevo": "mega 12"}	13
133	2021-11-18 13:07:57.242657	UPDATE	publicaciones	inventario	2	postgres	{}	12
134	2021-11-18 13:07:57.242657	UPDATE	publicaciones	inventario	2	postgres	{}	13
135	2021-11-18 13:07:57.242657	UPDATE	publicaciones	inventario	2	postgres	{}	14
136	2021-11-18 13:07:57.242657	UPDATE	publicaciones	inventario	2	postgres	{}	15
137	2021-11-18 13:07:57.242657	UPDATE	publicaciones	inventario	2	postgres	{}	16
138	2021-11-18 13:07:57.242657	UPDATE	publicaciones	inventario	5	postgres	{}	17
139	2021-11-18 13:07:57.242657	UPDATE	publicaciones	inventario	2	postgres	{}	18
140	2021-11-18 13:07:57.242657	UPDATE	publicaciones	inventario	2	postgres	{}	19
141	2021-11-18 13:23:00.532742	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 1, "status_anterior": 2}	12
142	2021-11-18 15:05:42.642212	UPDATE	publicaciones	inventario	2	postgres	{"tipo_bicicleta_nuevo": "MTB", "tipo_bicicleta_anterior": "Seleccione"}	14
143	2021-11-18 15:05:42.642212	UPDATE	publicaciones	inventario	2	postgres	{"tipo_bicicleta_nuevo": "MTB", "tipo_bicicleta_anterior": "Seleccione"}	15
144	2021-11-18 15:05:42.642212	UPDATE	publicaciones	inventario	2	postgres	{"tipo_bicicleta_nuevo": "MTB", "tipo_bicicleta_anterior": "Seleccione"}	16
145	2021-11-18 15:05:42.642212	UPDATE	publicaciones	inventario	2	postgres	{"tipo_bicicleta_nuevo": "MTB", "tipo_bicicleta_anterior": "Seleccione"}	18
146	2021-11-18 15:05:42.642212	UPDATE	publicaciones	inventario	2	postgres	{"tipo_bicicleta_nuevo": "MTB", "tipo_bicicleta_anterior": "Seleccione"}	19
147	2021-11-18 15:06:00.186023	UPDATE	publicaciones	inventario	2	postgres	{"talla_nuevo": "XL", "talla_anterior": "Seleccione"}	18
148	2021-11-18 15:34:32.63015	INSERT	publicaciones	tipo_bicicleta		postgres	{"id_nuevo": 5, "descripcion_nuevo": "BMX"}	5
149	2021-11-18 15:34:37.584171	INSERT	publicaciones	tipo_bicicleta		postgres	{"id_nuevo": 6, "descripcion_nuevo": "BMX"}	6
150	2021-11-18 15:34:40.71322	INSERT	publicaciones	tipo_bicicleta		postgres	{"id_nuevo": 7, "descripcion_nuevo": "BMX"}	7
151	2021-11-18 15:35:43.63978	DELETE	publicaciones	tipo_bicicleta		postgres	{"id_anterior": 6, "descripcion_anterior": "BMX"}	6
152	2021-11-18 15:35:43.63978	DELETE	publicaciones	tipo_bicicleta		postgres	{"id_anterior": 7, "descripcion_anterior": "BMX"}	7
153	2021-11-18 15:35:46.066821	INSERT	publicaciones	tipo_bicicleta		postgres	{"id_nuevo": 8, "descripcion_nuevo": "BMX"}	8
154	2021-11-18 15:35:52.410741	DELETE	publicaciones	tipo_bicicleta		postgres	{"id_anterior": 8, "descripcion_anterior": "BMX"}	8
155	2021-11-18 15:53:54.716143	UPDATE	usuarios	usuarios	admin	postgres	{"activo_nuevo": 0, "id_rol_nuevo": 0, "session_nuevo": "admin", "activo_anterior": 1, "id_rol_anterior": 1, "session_anterior": "1"}	1
156	2021-11-18 15:54:03.765304	UPDATE	usuarios	usuarios	admin	postgres	{}	1
157	2021-11-18 15:54:45.710008	UPDATE	usuarios	usuarios	admin	postgres	{}	1
158	2021-11-18 15:55:03.672564	UPDATE	publicaciones	subasta	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	1
159	2021-11-18 15:55:03.672564	UPDATE	publicaciones	subasta	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	3
160	2021-11-18 15:55:40.0248	UPDATE	usuarios	usuarios	admin	postgres	{}	1
161	2021-11-18 15:57:32.126709	UPDATE	usuarios	usuarios	admin	postgres	{"id_rol_nuevo": 1, "id_rol_anterior": 0}	1
162	2021-11-18 16:10:32.10443	UPDATE	usuarios	usuarios	admin	postgres	{"activo_nuevo": 1, "activo_anterior": 0}	1
163	2021-11-18 16:14:51.74855	UPDATE	usuarios	usuarios	admin	postgres	{"activo_nuevo": 0, "activo_anterior": 1}	1
164	2021-11-18 16:15:01.648371	UPDATE	usuarios	usuarios	admin	postgres	{}	1
165	2021-11-18 16:16:12.72427	UPDATE	usuarios	usuarios	admin	postgres	{}	1
166	2021-11-18 16:17:25.68038	UPDATE	usuarios	usuarios	admin	postgres	{"activo_nuevo": 1, "activo_anterior": 0}	1
167	2021-11-18 16:17:32.130501	UPDATE	usuarios	usuarios	admin	postgres	{"activo_nuevo": 0, "activo_anterior": 1}	1
168	2021-11-18 16:17:37.346179	UPDATE	usuarios	usuarios	admin	postgres	{"activo_nuevo": 1, "activo_anterior": 0}	1
169	2021-11-18 16:26:50.558894	UPDATE	publicaciones	subasta	2	postgres	{}	5
170	2021-11-18 16:29:33.391615	UPDATE	publicaciones	subasta	2	postgres	{}	1
171	2021-11-18 16:29:33.391615	UPDATE	publicaciones	subasta	2	postgres	{}	2
172	2021-11-18 16:29:33.391615	UPDATE	publicaciones	subasta	2	postgres	{}	3
173	2021-11-18 16:29:33.391615	UPDATE	publicaciones	subasta	5	postgres	{}	4
174	2021-11-18 16:29:33.391615	UPDATE	publicaciones	subasta	2	postgres	{}	5
175	2021-11-18 16:30:27.691704	UPDATE	publicaciones	inventario	2	postgres	{}	15
176	2021-11-18 16:30:27.691704	UPDATE	publicaciones	inventario	2	postgres	{}	16
177	2021-11-18 16:30:27.691704	UPDATE	publicaciones	inventario	5	postgres	{}	17
178	2021-11-18 16:30:27.691704	UPDATE	publicaciones	inventario	2	postgres	{}	19
179	2021-11-18 16:30:39.292688	UPDATE	publicaciones	inventario	2	postgres	{}	13
180	2021-11-18 16:35:04.478791	UPDATE	publicaciones	inventario	2	postgres	{}	13
181	2021-11-18 16:35:04.478791	UPDATE	publicaciones	inventario	2	postgres	{}	15
182	2021-11-18 16:35:04.478791	UPDATE	publicaciones	inventario	2	postgres	{}	16
183	2021-11-18 16:35:04.478791	UPDATE	publicaciones	inventario	5	postgres	{}	17
184	2021-11-18 16:35:04.478791	UPDATE	publicaciones	inventario	2	postgres	{}	19
185	2021-11-18 17:33:22.538565	UPDATE	publicaciones	subasta	2	postgres	{}	1
186	2021-11-18 17:41:33.151598	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": true, "correo_anterior": false}	1
187	2021-11-18 17:41:34.561461	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": true, "correo_anterior": false}	2
188	2021-11-18 17:41:35.905504	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": true, "correo_anterior": false}	3
189	2021-11-18 17:41:37.221773	UPDATE	publicaciones	subasta	5	postgres	{"correo_nuevo": true, "correo_anterior": false}	4
190	2021-11-18 17:44:44.565376	UPDATE	publicaciones	subasta	2	postgres	{"status_nuevo": 2, "status_anterior": 3}	1
191	2021-11-18 17:44:58.402564	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": false, "correo_anterior": true}	1
192	2021-11-18 17:49:12.02244	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": true, "correo_anterior": false}	1
193	2021-11-18 17:51:03.682426	UPDATE	publicaciones	inventario	2	postgres	{"status_nuevo": 3, "status_anterior": 1}	12
194	2021-11-18 17:51:03.729838	INSERT	publicaciones	subasta	2	postgres	{"id_nuevo": 6, "correo_nuevo": false, "status_nuevo": 1, "session_nuevo": "2", "fecha_fin_nuevo": "2021-11-18T17:53:03.719311", "puja_alta_nuevo": 1000000, "id_cliente_nuevo": 2, "id_producto_nuevo": 12, "modified_by_nuevo": "2021-11-18T17:51:03.729838", "fecha_inicio_nuevo": "2021-11-18T17:51:03.719311", "id_comprador_nuevo": null, "valor_inicial_nuevo": 1000000}	6
195	2021-11-18 17:51:26.712918	INSERT	publicaciones	historico_subastas		postgres	{"id_nuevo": 7, "valor_nuevo": 1000001, "id_subasta_nuevo": 6, "id_comprador_nuevo": 4}	7
196	2021-11-18 17:51:26.760787	UPDATE	publicaciones	subasta	2	postgres	{"puja_alta_nuevo": 1000001, "puja_alta_anterior": 1000000}	6
197	2021-11-18 17:53:04.626966	UPDATE	publicaciones	subasta	2	postgres	{"status_nuevo": 2, "status_anterior": 1}	6
198	2021-11-18 17:56:51.430002	UPDATE	publicaciones	subasta	2	postgres	{}	6
199	2021-11-18 17:57:42.1586	UPDATE	publicaciones	subasta	2	postgres	{}	2
200	2021-11-18 17:57:42.1586	UPDATE	publicaciones	subasta	2	postgres	{}	3
201	2021-11-18 17:57:42.1586	UPDATE	publicaciones	subasta	5	postgres	{}	4
202	2021-11-18 18:03:35.14634	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": true, "correo_anterior": false}	6
203	2021-11-18 18:16:55.983555	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": false, "correo_anterior": true}	6
204	2021-11-18 18:17:53.465569	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": true, "correo_anterior": false}	6
205	2021-11-18 18:29:09.274796	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": false, "correo_anterior": true}	6
206	2021-11-18 18:35:15.844426	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": true, "correo_anterior": false}	6
207	2021-11-18 18:37:57.388513	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": false, "correo_anterior": true}	6
208	2021-11-18 18:38:36.3829	UPDATE	publicaciones	subasta	2	postgres	{"correo_nuevo": true, "correo_anterior": false}	6
\.


                                                                                                                                                                                                                  3143.dat                                                                                            0000600 0004000 0002000 00000000167 14145571010 0014246 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	desarrollador	sistema	14:14:02.001786
2	administrador	sistema	14:14:02.001786
3	cliente	sistema	14:14:02.001786
\.


                                                                                                                                                                                                                                                                                                                                                                                                         3144.dat                                                                                            0000600 0004000 0002000 00000002712 14145571010 0014245 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	2021-10-13 19:09:52.598553	2021-10-13 19:19:52.598553	f58ba16144f64cbe7cf3107f66657a1d69536a7f4c256ca15bb50c58006426d0	1
2	2021-10-13 19:10:41.08674	2021-10-13 19:20:41.08674	a79090ef5cc134a750612e09f50576d3b12a7514a76e124c6769fc8a2374fc67	1
3	2021-10-13 19:10:55.898355	2021-10-13 19:20:55.898355	97f1accdea1b3ad835984b83e3995892f30774b8134526ac0491bedc9ed702d7	1
4	2021-10-13 19:11:33.059581	2021-10-13 19:21:33.059581	80c34d7965ad964585b63dda9f9a45fd084fe694bd75daeab813b2ed43644191	1
5	2021-10-13 19:12:01.490565	2021-10-13 19:22:01.490565	5c07e8d976abe203078a6517108de94a6243c1d8394a2350ab0cf8fa3089b293	1
6	2021-10-13 19:22:38.299021	2021-10-13 19:32:38.299021	65df8e1b5b669394778a54c21861688e6518a4c5982c5dbba1d7b54e084a2f3a	1
7	2021-10-13 19:42:01.873177	2021-10-13 19:52:01.873177	7b5a143774d13b25ce73ac79a2e71dc6cac8800a739d6f133d1a5b32179d1f2e	2
8	2021-10-16 11:13:28.641383	2021-10-16 11:23:28.641383	20f05c8c6aad89e69975b2b9d6788e1e916a9db0af09129b8f83dba3793be5ca	1
9	2021-10-16 11:15:44.789742	2021-10-16 11:25:44.789742	1581c0d1eed921f7a987821b404c2f0b92aaf95de8b3c6f010366e270d6453a9	1
10	2021-10-22 14:50:00.116009	2021-10-22 15:00:00.117018	94d7ff7dfce7d98e9b7bebb48e36d6a3caec8ea1606f6c45dfe20119907b5937	1
11	2021-10-22 15:46:35.630623	2021-10-22 15:56:36.139044	3324468686c73b8fbf2018f326ad2d5c1934b723870d6c1e53fd0fb2b5d44df6	2
12	2021-10-27 13:00:24.587778	2021-10-27 13:10:24.587778	205f0ec9213019893b6f53f258440a861dd429c1fa67f7919a9ec4fd242ddaaf	2
\.


                                                      3145.dat                                                                                            0000600 0004000 0002000 00000001045 14145571010 0014244 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	Esteban 	Gomez Gomez	eysonesteban1998@gmail.com	estleon	3	web	19:33:53.666204	cQB3AGUAMQAyADMAYQBzAA==	3203911338	1	t
3	oscar	gomez	owlblack10@gmail.com	oscar	2	web	16:00:48.409683	cQB3AGUAMQAyADMAYQBzAA==	3138582047	1	f
4	pedro	picapiedra	bojacasa@gmail.com	pedro	3	4	16:45:00.375528	cQB3AGUAMQAyADMAYQBzAA==	3112794086	1	f
5	prueba	prueba	mongee1@gmail.com	prueba	3	web	08:02:59.229987	cAByAHUAZQBiAGEA	3124583735	1	f
1	David Leonardo	Gomez Ochoa	bojacasa@gmail.com	oxgerrero	1	admin	16:38:39.247527	cQB3AGUAMQAyADMAYQBzAA==	3112794086	1	f
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           restore.sql                                                                                         0000600 0004000 0002000 00000215077 14145571010 0015376 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.4
-- Dumped by pg_dump version 13.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE bike;
--
-- Name: bike; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE bike WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'Spanish_Colombia.1252';


ALTER DATABASE bike OWNER TO postgres;

\connect bike

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: publicaciones; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA publicaciones;


ALTER SCHEMA publicaciones OWNER TO postgres;

--
-- Name: security; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA security;


ALTER SCHEMA security OWNER TO postgres;

--
-- Name: usuarios; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA usuarios;


ALTER SCHEMA usuarios OWNER TO postgres;

--
-- Name: f_log_auditoria(); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.f_log_auditoria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
		_pk TEXT :='';		-- Representa la llave primaria de la tabla que esta siedno modificada.
		_sql TEXT;		-- Variable para la creacion del procedured.
		_column_guia RECORD; 	-- Variable para el FOR guarda los nombre de las columnas.
		_column_key RECORD; 	-- Variable para el FOR guarda los PK de las columnas.
		_session TEXT;	-- Almacena el usuario que genera el cambio.
		_user_db TEXT;		-- Almacena el usuario de bd que genera la transaccion.
		_control INT;		-- Variabel de control par alas llaves primarias.
		_count_key INT = 0;	-- Cantidad de columnas pertenecientes al PK.
		_sql_insert TEXT;	-- Variable para la construcción del insert del json de forma dinamica.
		_sql_delete TEXT;	-- Variable para la construcción del delete del json de forma dinamica.
		_sql_update TEXT;	-- Variable para la construcción del update del json de forma dinamica.
		_new_data RECORD; 	-- Fila que representa los campos nuevos del registro.
		_old_data RECORD;	-- Fila que representa los campos viejos del registro.

	BEGIN

			-- Se genera la evaluacion para determianr el tipo de accion sobre la tabla
		 IF (TG_OP = 'INSERT') THEN
			_new_data := NEW;
			_old_data := NEW;
		ELSEIF (TG_OP = 'UPDATE') THEN
			_new_data := NEW;
			_old_data := OLD;
		ELSE
			_new_data := OLD;
			_old_data := OLD;
		END IF;

		-- Se genera la evaluacion para determianr el tipo de accion sobre la tabla
		IF ((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME AND column_name = 'id' ) > 0) THEN
			_pk := _new_data.id;
		ELSE
			_pk := '-1';
		END IF;

		-- Se valida que exista el campo modified_by
		IF ((SELECT COUNT(*) FROM information_schema.columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME AND column_name = 'session') > 0) THEN
			_session := _new_data.session;
		ELSE
			_session := '';
		END IF;

		-- Se guarda el susuario de bd que genera la transaccion
		_user_db := (SELECT CURRENT_USER);

		-- Se evalua que exista el procedimeinto adecuado
		IF (SELECT COUNT(*) FROM security.function_db_view acfdv WHERE acfdv.b_function = 'field_audit' AND acfdv.b_type_parameters = TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', character varying, character varying, character varying, text, character varying, text, text') > 0
			THEN
				-- Se realiza la invocación del procedured generado dinamivamente
				PERFORM security.field_audit(_new_data, _old_data, TG_OP, _session, _user_db , _pk, ''::text);
		ELSE
			-- Se empieza la construcción del Procedured generico
			_sql := 'CREATE OR REPLACE FUNCTION security.field_audit( _data_new '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _data_old '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _accion character varying, _session text, _user_db character varying, _table_pk text, _init text)'
			|| ' RETURNS TEXT AS ''
'
			|| '
'
	|| '	DECLARE
'
	|| '		_column_data TEXT;
	 	_datos jsonb;
	 	
'
	|| '	BEGIN
			_datos = ''''{}'''';
';
			-- Se evalua si hay que actualizar la pk del registro de auditoria.
			IF _pk = '-1'
				THEN
					_sql := _sql
					|| '
		_column_data := ';

					-- Se genera el update con la clave pk de la tabla
					SELECT
						COUNT(isk.column_name)
					INTO
						_control
					FROM
						information_schema.table_constraints istc JOIN information_schema.key_column_usage isk ON isk.constraint_name = istc.constraint_name
					WHERE
						istc.table_schema = TG_TABLE_SCHEMA
					 AND	istc.table_name = TG_TABLE_NAME
					 AND	istc.constraint_type ilike '%primary%';

					-- Se agregan las columnas que componen la pk de la tabla.
					FOR _column_key IN SELECT
							isk.column_name
						FROM
							information_schema.table_constraints istc JOIN information_schema.key_column_usage isk ON isk.constraint_name = istc.constraint_name
						WHERE
							istc.table_schema = TG_TABLE_SCHEMA
						 AND	istc.table_name = TG_TABLE_NAME
						 AND	istc.constraint_type ilike '%primary%'
						ORDER BY 
							isk.ordinal_position  LOOP

						_sql := _sql || ' _data_new.' || _column_key.column_name;
						
						_count_key := _count_key + 1 ;
						
						IF _count_key < _control THEN
							_sql :=	_sql || ' || ' || ''''',''''' || ' ||';
						END IF;
					END LOOP;
				_sql := _sql || ';';
			END IF;

			_sql_insert:='
		IF _accion = ''''INSERT''''
			THEN
				';
			_sql_delete:='
		ELSEIF _accion = ''''DELETE''''
			THEN
				';
			_sql_update:='
		ELSE
			';

			-- Se genera el ciclo de agregado de columnas para el nuevo procedured
			FOR _column_guia IN SELECT column_name, data_type FROM information_schema.columns WHERE table_schema = TG_TABLE_SCHEMA AND table_name = TG_TABLE_NAME
				LOOP
						
					_sql_insert:= _sql_insert || '_datos := _datos || json_build_object('''''
					|| _column_guia.column_name
					|| '_nuevo'
					|| ''''', '
					|| '_data_new.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea', 'USER-DEFINED') THEN 
						_sql_insert:= _sql_insert
						||'::text';
					END IF;

					_sql_insert:= _sql_insert || ')::jsonb;
				';

					_sql_delete := _sql_delete || '_datos := _datos || json_build_object('''''
					|| _column_guia.column_name
					|| '_anterior'
					|| ''''', '
					|| '_data_old.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea', 'USER-DEFINED') THEN 
						_sql_delete:= _sql_delete
						||'::text';
					END IF;

					_sql_delete:= _sql_delete || ')::jsonb;
				';

					_sql_update := _sql_update || 'IF _data_old.' || _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea','USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update || ' <> _data_new.' || _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea','USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update || '
				THEN _datos := _datos || json_build_object('''''
					|| _column_guia.column_name
					|| '_anterior'
					|| ''''', '
					|| '_data_old.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea','USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update
					|| ', '''''
					|| _column_guia.column_name
					|| '_nuevo'
					|| ''''', _data_new.'
					|| _column_guia.column_name;

					IF _column_guia.data_type IN ('bytea', 'USER-DEFINED') THEN 
						_sql_update:= _sql_update
						||'::text';
					END IF;

					_sql_update:= _sql_update
					|| ')::jsonb;
			END IF;
			';
			END LOOP;

			-- Se le agrega la parte final del procedured generico
			
			_sql:= _sql || _sql_insert || _sql_delete || _sql_update
			|| ' 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			''''' || TG_TABLE_SCHEMA || ''''',
			''''' || TG_TABLE_NAME || ''''',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;'''
|| '
LANGUAGE plpgsql;

GRANT EXECUTE ON FUNCTION security.field_audit( _data_new '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _data_old '|| TG_TABLE_SCHEMA || '.'|| TG_TABLE_NAME || ', _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) TO postgres;
';

			-- Se genera la ejecución de _sql, es decir se crea el nuevo procedured de forma generica.
			EXECUTE _sql;

		-- Se realiza la invocación del procedured generado dinamivamente
			 PERFORM security.field_audit(_new_data, _old_data, TG_OP::character varying, _session, _user_db, _pk, ''::text);

		END IF;

		RETURN NULL;

END;
$$;


ALTER FUNCTION security.f_log_auditoria() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: historico_subastas; Type: TABLE; Schema: publicaciones; Owner: postgres
--

CREATE TABLE publicaciones.historico_subastas (
    id integer NOT NULL,
    id_comprador integer NOT NULL,
    id_subasta integer NOT NULL,
    valor integer NOT NULL
);


ALTER TABLE publicaciones.historico_subastas OWNER TO postgres;

--
-- Name: field_audit(publicaciones.historico_subastas, publicaciones.historico_subastas, character varying, text, character varying, text, text); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.field_audit(_data_new publicaciones.historico_subastas, _data_old publicaciones.historico_subastas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('id_comprador_nuevo', _data_new.id_comprador)::jsonb;
				_datos := _datos || json_build_object('id_subasta_nuevo', _data_new.id_subasta)::jsonb;
				_datos := _datos || json_build_object('valor_nuevo', _data_new.valor)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador)::jsonb;
				_datos := _datos || json_build_object('id_subasta_anterior', _data_old.id_subasta)::jsonb;
				_datos := _datos || json_build_object('valor_anterior', _data_old.valor)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.id_comprador <> _data_new.id_comprador
				THEN _datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador, 'id_comprador_nuevo', _data_new.id_comprador)::jsonb;
			END IF;
			IF _data_old.id_subasta <> _data_new.id_subasta
				THEN _datos := _datos || json_build_object('id_subasta_anterior', _data_old.id_subasta, 'id_subasta_nuevo', _data_new.id_subasta)::jsonb;
			END IF;
			IF _data_old.valor <> _data_new.valor
				THEN _datos := _datos || json_build_object('valor_anterior', _data_old.valor, 'valor_nuevo', _data_new.valor)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'historico_subastas',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;


ALTER FUNCTION security.field_audit(_data_new publicaciones.historico_subastas, _data_old publicaciones.historico_subastas, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) OWNER TO postgres;

--
-- Name: inventario; Type: TABLE; Schema: publicaciones; Owner: postgres
--

CREATE TABLE publicaciones.inventario (
    id integer NOT NULL,
    imagen1 text NOT NULL,
    imagen2 text NOT NULL,
    imagen3 text NOT NULL,
    precio integer NOT NULL,
    status integer NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    modified_by time without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    talla text NOT NULL,
    referencia text NOT NULL,
    marca text NOT NULL,
    id_vendedor integer NOT NULL,
    id_comprador integer NOT NULL,
    fecha_revicion date NOT NULL,
    color text NOT NULL,
    "año" date NOT NULL,
    ciudad text NOT NULL,
    tipo_bicicleta text NOT NULL,
    tipo_frenos text NOT NULL,
    "n_piñones" text NOT NULL,
    correo boolean DEFAULT false NOT NULL
);


ALTER TABLE publicaciones.inventario OWNER TO postgres;

--
-- Name: field_audit(publicaciones.inventario, publicaciones.inventario, character varying, text, character varying, text, text); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.field_audit(_data_new publicaciones.inventario, _data_old publicaciones.inventario, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('imagen1_nuevo', _data_new.imagen1)::jsonb;
				_datos := _datos || json_build_object('imagen2_nuevo', _data_new.imagen2)::jsonb;
				_datos := _datos || json_build_object('imagen3_nuevo', _data_new.imagen3)::jsonb;
				_datos := _datos || json_build_object('precio_nuevo', _data_new.precio)::jsonb;
				_datos := _datos || json_build_object('status_nuevo', _data_new.status)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				_datos := _datos || json_build_object('talla_nuevo', _data_new.talla)::jsonb;
				_datos := _datos || json_build_object('referencia_nuevo', _data_new.referencia)::jsonb;
				_datos := _datos || json_build_object('marca_nuevo', _data_new.marca)::jsonb;
				_datos := _datos || json_build_object('id_vendedor_nuevo', _data_new.id_vendedor)::jsonb;
				_datos := _datos || json_build_object('id_comprador_nuevo', _data_new.id_comprador)::jsonb;
				_datos := _datos || json_build_object('fecha_revicion_nuevo', _data_new.fecha_revicion)::jsonb;
				_datos := _datos || json_build_object('color_nuevo', _data_new.color)::jsonb;
				_datos := _datos || json_build_object('año_nuevo', _data_new.año)::jsonb;
				_datos := _datos || json_build_object('ciudad_nuevo', _data_new.ciudad)::jsonb;
				_datos := _datos || json_build_object('tipo_bicicleta_nuevo', _data_new.tipo_bicicleta)::jsonb;
				_datos := _datos || json_build_object('tipo_frenos_nuevo', _data_new.tipo_frenos)::jsonb;
				_datos := _datos || json_build_object('n_piñones_nuevo', _data_new.n_piñones)::jsonb;
				_datos := _datos || json_build_object('correo_nuevo', _data_new.correo)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('imagen1_anterior', _data_old.imagen1)::jsonb;
				_datos := _datos || json_build_object('imagen2_anterior', _data_old.imagen2)::jsonb;
				_datos := _datos || json_build_object('imagen3_anterior', _data_old.imagen3)::jsonb;
				_datos := _datos || json_build_object('precio_anterior', _data_old.precio)::jsonb;
				_datos := _datos || json_build_object('status_anterior', _data_old.status)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				_datos := _datos || json_build_object('talla_anterior', _data_old.talla)::jsonb;
				_datos := _datos || json_build_object('referencia_anterior', _data_old.referencia)::jsonb;
				_datos := _datos || json_build_object('marca_anterior', _data_old.marca)::jsonb;
				_datos := _datos || json_build_object('id_vendedor_anterior', _data_old.id_vendedor)::jsonb;
				_datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador)::jsonb;
				_datos := _datos || json_build_object('fecha_revicion_anterior', _data_old.fecha_revicion)::jsonb;
				_datos := _datos || json_build_object('color_anterior', _data_old.color)::jsonb;
				_datos := _datos || json_build_object('año_anterior', _data_old.año)::jsonb;
				_datos := _datos || json_build_object('ciudad_anterior', _data_old.ciudad)::jsonb;
				_datos := _datos || json_build_object('tipo_bicicleta_anterior', _data_old.tipo_bicicleta)::jsonb;
				_datos := _datos || json_build_object('tipo_frenos_anterior', _data_old.tipo_frenos)::jsonb;
				_datos := _datos || json_build_object('n_piñones_anterior', _data_old.n_piñones)::jsonb;
				_datos := _datos || json_build_object('correo_anterior', _data_old.correo)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.imagen1 <> _data_new.imagen1
				THEN _datos := _datos || json_build_object('imagen1_anterior', _data_old.imagen1, 'imagen1_nuevo', _data_new.imagen1)::jsonb;
			END IF;
			IF _data_old.imagen2 <> _data_new.imagen2
				THEN _datos := _datos || json_build_object('imagen2_anterior', _data_old.imagen2, 'imagen2_nuevo', _data_new.imagen2)::jsonb;
			END IF;
			IF _data_old.imagen3 <> _data_new.imagen3
				THEN _datos := _datos || json_build_object('imagen3_anterior', _data_old.imagen3, 'imagen3_nuevo', _data_new.imagen3)::jsonb;
			END IF;
			IF _data_old.precio <> _data_new.precio
				THEN _datos := _datos || json_build_object('precio_anterior', _data_old.precio, 'precio_nuevo', _data_new.precio)::jsonb;
			END IF;
			IF _data_old.status <> _data_new.status
				THEN _datos := _datos || json_build_object('status_anterior', _data_old.status, 'status_nuevo', _data_new.status)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			IF _data_old.talla <> _data_new.talla
				THEN _datos := _datos || json_build_object('talla_anterior', _data_old.talla, 'talla_nuevo', _data_new.talla)::jsonb;
			END IF;
			IF _data_old.referencia <> _data_new.referencia
				THEN _datos := _datos || json_build_object('referencia_anterior', _data_old.referencia, 'referencia_nuevo', _data_new.referencia)::jsonb;
			END IF;
			IF _data_old.marca <> _data_new.marca
				THEN _datos := _datos || json_build_object('marca_anterior', _data_old.marca, 'marca_nuevo', _data_new.marca)::jsonb;
			END IF;
			IF _data_old.id_vendedor <> _data_new.id_vendedor
				THEN _datos := _datos || json_build_object('id_vendedor_anterior', _data_old.id_vendedor, 'id_vendedor_nuevo', _data_new.id_vendedor)::jsonb;
			END IF;
			IF _data_old.id_comprador <> _data_new.id_comprador
				THEN _datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador, 'id_comprador_nuevo', _data_new.id_comprador)::jsonb;
			END IF;
			IF _data_old.fecha_revicion <> _data_new.fecha_revicion
				THEN _datos := _datos || json_build_object('fecha_revicion_anterior', _data_old.fecha_revicion, 'fecha_revicion_nuevo', _data_new.fecha_revicion)::jsonb;
			END IF;
			IF _data_old.color <> _data_new.color
				THEN _datos := _datos || json_build_object('color_anterior', _data_old.color, 'color_nuevo', _data_new.color)::jsonb;
			END IF;
			IF _data_old.año <> _data_new.año
				THEN _datos := _datos || json_build_object('año_anterior', _data_old.año, 'año_nuevo', _data_new.año)::jsonb;
			END IF;
			IF _data_old.ciudad <> _data_new.ciudad
				THEN _datos := _datos || json_build_object('ciudad_anterior', _data_old.ciudad, 'ciudad_nuevo', _data_new.ciudad)::jsonb;
			END IF;
			IF _data_old.tipo_bicicleta <> _data_new.tipo_bicicleta
				THEN _datos := _datos || json_build_object('tipo_bicicleta_anterior', _data_old.tipo_bicicleta, 'tipo_bicicleta_nuevo', _data_new.tipo_bicicleta)::jsonb;
			END IF;
			IF _data_old.tipo_frenos <> _data_new.tipo_frenos
				THEN _datos := _datos || json_build_object('tipo_frenos_anterior', _data_old.tipo_frenos, 'tipo_frenos_nuevo', _data_new.tipo_frenos)::jsonb;
			END IF;
			IF _data_old.n_piñones <> _data_new.n_piñones
				THEN _datos := _datos || json_build_object('n_piñones_anterior', _data_old.n_piñones, 'n_piñones_nuevo', _data_new.n_piñones)::jsonb;
			END IF;
			IF _data_old.correo <> _data_new.correo
				THEN _datos := _datos || json_build_object('correo_anterior', _data_old.correo, 'correo_nuevo', _data_new.correo)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'inventario',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;


ALTER FUNCTION security.field_audit(_data_new publicaciones.inventario, _data_old publicaciones.inventario, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) OWNER TO postgres;

--
-- Name: piniones; Type: TABLE; Schema: publicaciones; Owner: postgres
--

CREATE TABLE publicaciones.piniones (
    id integer NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE publicaciones.piniones OWNER TO postgres;

--
-- Name: field_audit(publicaciones.piniones, publicaciones.piniones, character varying, text, character varying, text, text); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.field_audit(_data_new publicaciones.piniones, _data_old publicaciones.piniones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('descripcion_nuevo', _data_new.descripcion)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.descripcion <> _data_new.descripcion
				THEN _datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion, 'descripcion_nuevo', _data_new.descripcion)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'piniones',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;


ALTER FUNCTION security.field_audit(_data_new publicaciones.piniones, _data_old publicaciones.piniones, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) OWNER TO postgres;

--
-- Name: pqrs; Type: TABLE; Schema: publicaciones; Owner: postgres
--

CREATE TABLE publicaciones.pqrs (
    id integer NOT NULL,
    id_publicacion integer NOT NULL,
    id_cliente_reporto integer NOT NULL,
    descripcion text NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    modified_by timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    status integer
);


ALTER TABLE publicaciones.pqrs OWNER TO postgres;

--
-- Name: field_audit(publicaciones.pqrs, publicaciones.pqrs, character varying, text, character varying, text, text); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.field_audit(_data_new publicaciones.pqrs, _data_old publicaciones.pqrs, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('id_publicacion_nuevo', _data_new.id_publicacion)::jsonb;
				_datos := _datos || json_build_object('id_cliente_reporto_nuevo', _data_new.id_cliente_reporto)::jsonb;
				_datos := _datos || json_build_object('descripcion_nuevo', _data_new.descripcion)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				_datos := _datos || json_build_object('status_nuevo', _data_new.status)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('id_publicacion_anterior', _data_old.id_publicacion)::jsonb;
				_datos := _datos || json_build_object('id_cliente_reporto_anterior', _data_old.id_cliente_reporto)::jsonb;
				_datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				_datos := _datos || json_build_object('status_anterior', _data_old.status)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.id_publicacion <> _data_new.id_publicacion
				THEN _datos := _datos || json_build_object('id_publicacion_anterior', _data_old.id_publicacion, 'id_publicacion_nuevo', _data_new.id_publicacion)::jsonb;
			END IF;
			IF _data_old.id_cliente_reporto <> _data_new.id_cliente_reporto
				THEN _datos := _datos || json_build_object('id_cliente_reporto_anterior', _data_old.id_cliente_reporto, 'id_cliente_reporto_nuevo', _data_new.id_cliente_reporto)::jsonb;
			END IF;
			IF _data_old.descripcion <> _data_new.descripcion
				THEN _datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion, 'descripcion_nuevo', _data_new.descripcion)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			IF _data_old.status <> _data_new.status
				THEN _datos := _datos || json_build_object('status_anterior', _data_old.status, 'status_nuevo', _data_new.status)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'pqrs',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;


ALTER FUNCTION security.field_audit(_data_new publicaciones.pqrs, _data_old publicaciones.pqrs, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) OWNER TO postgres;

--
-- Name: subasta; Type: TABLE; Schema: publicaciones; Owner: postgres
--

CREATE TABLE publicaciones.subasta (
    id integer NOT NULL,
    valor_inicial integer NOT NULL,
    status integer NOT NULL,
    puja_alta integer NOT NULL,
    id_producto integer NOT NULL,
    id_cliente integer NOT NULL,
    fecha_inicio timestamp without time zone NOT NULL,
    fecha_fin timestamp without time zone NOT NULL,
    modified_by timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    id_comprador integer NOT NULL,
    correo boolean DEFAULT false NOT NULL
);


ALTER TABLE publicaciones.subasta OWNER TO postgres;

--
-- Name: field_audit(publicaciones.subasta, publicaciones.subasta, character varying, text, character varying, text, text); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.field_audit(_data_new publicaciones.subasta, _data_old publicaciones.subasta, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('valor_inicial_nuevo', _data_new.valor_inicial)::jsonb;
				_datos := _datos || json_build_object('status_nuevo', _data_new.status)::jsonb;
				_datos := _datos || json_build_object('puja_alta_nuevo', _data_new.puja_alta)::jsonb;
				_datos := _datos || json_build_object('id_producto_nuevo', _data_new.id_producto)::jsonb;
				_datos := _datos || json_build_object('id_cliente_nuevo', _data_new.id_cliente)::jsonb;
				_datos := _datos || json_build_object('fecha_inicio_nuevo', _data_new.fecha_inicio)::jsonb;
				_datos := _datos || json_build_object('fecha_fin_nuevo', _data_new.fecha_fin)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('id_comprador_nuevo', _data_new.id_comprador)::jsonb;
				_datos := _datos || json_build_object('correo_nuevo', _data_new.correo)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('valor_inicial_anterior', _data_old.valor_inicial)::jsonb;
				_datos := _datos || json_build_object('status_anterior', _data_old.status)::jsonb;
				_datos := _datos || json_build_object('puja_alta_anterior', _data_old.puja_alta)::jsonb;
				_datos := _datos || json_build_object('id_producto_anterior', _data_old.id_producto)::jsonb;
				_datos := _datos || json_build_object('id_cliente_anterior', _data_old.id_cliente)::jsonb;
				_datos := _datos || json_build_object('fecha_inicio_anterior', _data_old.fecha_inicio)::jsonb;
				_datos := _datos || json_build_object('fecha_fin_anterior', _data_old.fecha_fin)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador)::jsonb;
				_datos := _datos || json_build_object('correo_anterior', _data_old.correo)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.valor_inicial <> _data_new.valor_inicial
				THEN _datos := _datos || json_build_object('valor_inicial_anterior', _data_old.valor_inicial, 'valor_inicial_nuevo', _data_new.valor_inicial)::jsonb;
			END IF;
			IF _data_old.status <> _data_new.status
				THEN _datos := _datos || json_build_object('status_anterior', _data_old.status, 'status_nuevo', _data_new.status)::jsonb;
			END IF;
			IF _data_old.puja_alta <> _data_new.puja_alta
				THEN _datos := _datos || json_build_object('puja_alta_anterior', _data_old.puja_alta, 'puja_alta_nuevo', _data_new.puja_alta)::jsonb;
			END IF;
			IF _data_old.id_producto <> _data_new.id_producto
				THEN _datos := _datos || json_build_object('id_producto_anterior', _data_old.id_producto, 'id_producto_nuevo', _data_new.id_producto)::jsonb;
			END IF;
			IF _data_old.id_cliente <> _data_new.id_cliente
				THEN _datos := _datos || json_build_object('id_cliente_anterior', _data_old.id_cliente, 'id_cliente_nuevo', _data_new.id_cliente)::jsonb;
			END IF;
			IF _data_old.fecha_inicio <> _data_new.fecha_inicio
				THEN _datos := _datos || json_build_object('fecha_inicio_anterior', _data_old.fecha_inicio, 'fecha_inicio_nuevo', _data_new.fecha_inicio)::jsonb;
			END IF;
			IF _data_old.fecha_fin <> _data_new.fecha_fin
				THEN _datos := _datos || json_build_object('fecha_fin_anterior', _data_old.fecha_fin, 'fecha_fin_nuevo', _data_new.fecha_fin)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.id_comprador <> _data_new.id_comprador
				THEN _datos := _datos || json_build_object('id_comprador_anterior', _data_old.id_comprador, 'id_comprador_nuevo', _data_new.id_comprador)::jsonb;
			END IF;
			IF _data_old.correo <> _data_new.correo
				THEN _datos := _datos || json_build_object('correo_anterior', _data_old.correo, 'correo_nuevo', _data_new.correo)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'subasta',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;


ALTER FUNCTION security.field_audit(_data_new publicaciones.subasta, _data_old publicaciones.subasta, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) OWNER TO postgres;

--
-- Name: tipo_bicicleta; Type: TABLE; Schema: publicaciones; Owner: postgres
--

CREATE TABLE publicaciones.tipo_bicicleta (
    id integer NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE publicaciones.tipo_bicicleta OWNER TO postgres;

--
-- Name: field_audit(publicaciones.tipo_bicicleta, publicaciones.tipo_bicicleta, character varying, text, character varying, text, text); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.field_audit(_data_new publicaciones.tipo_bicicleta, _data_old publicaciones.tipo_bicicleta, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('descripcion_nuevo', _data_new.descripcion)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.descripcion <> _data_new.descripcion
				THEN _datos := _datos || json_build_object('descripcion_anterior', _data_old.descripcion, 'descripcion_nuevo', _data_new.descripcion)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'publicaciones',
			'tipo_bicicleta',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;


ALTER FUNCTION security.field_audit(_data_new publicaciones.tipo_bicicleta, _data_old publicaciones.tipo_bicicleta, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) OWNER TO postgres;

--
-- Name: rol; Type: TABLE; Schema: usuarios; Owner: postgres
--

CREATE TABLE usuarios.rol (
    id integer NOT NULL,
    desripcion text NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    modified_by time without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE usuarios.rol OWNER TO postgres;

--
-- Name: field_audit(usuarios.rol, usuarios.rol, character varying, text, character varying, text, text); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.field_audit(_data_new usuarios.rol, _data_old usuarios.rol, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('desripcion_nuevo', _data_new.desripcion)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('desripcion_anterior', _data_old.desripcion)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.desripcion <> _data_new.desripcion
				THEN _datos := _datos || json_build_object('desripcion_anterior', _data_old.desripcion, 'desripcion_nuevo', _data_new.desripcion)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'usuarios',
			'rol',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;


ALTER FUNCTION security.field_audit(_data_new usuarios.rol, _data_old usuarios.rol, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) OWNER TO postgres;

--
-- Name: token; Type: TABLE; Schema: usuarios; Owner: postgres
--

CREATE TABLE usuarios.token (
    id integer NOT NULL,
    finicio timestamp without time zone NOT NULL,
    ffin timestamp without time zone NOT NULL,
    tactivo text NOT NULL,
    id_user integer NOT NULL
);


ALTER TABLE usuarios.token OWNER TO postgres;

--
-- Name: field_audit(usuarios.token, usuarios.token, character varying, text, character varying, text, text); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.field_audit(_data_new usuarios.token, _data_old usuarios.token, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('finicio_nuevo', _data_new.finicio)::jsonb;
				_datos := _datos || json_build_object('ffin_nuevo', _data_new.ffin)::jsonb;
				_datos := _datos || json_build_object('tactivo_nuevo', _data_new.tactivo)::jsonb;
				_datos := _datos || json_build_object('id_user_nuevo', _data_new.id_user)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('finicio_anterior', _data_old.finicio)::jsonb;
				_datos := _datos || json_build_object('ffin_anterior', _data_old.ffin)::jsonb;
				_datos := _datos || json_build_object('tactivo_anterior', _data_old.tactivo)::jsonb;
				_datos := _datos || json_build_object('id_user_anterior', _data_old.id_user)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.finicio <> _data_new.finicio
				THEN _datos := _datos || json_build_object('finicio_anterior', _data_old.finicio, 'finicio_nuevo', _data_new.finicio)::jsonb;
			END IF;
			IF _data_old.ffin <> _data_new.ffin
				THEN _datos := _datos || json_build_object('ffin_anterior', _data_old.ffin, 'ffin_nuevo', _data_new.ffin)::jsonb;
			END IF;
			IF _data_old.tactivo <> _data_new.tactivo
				THEN _datos := _datos || json_build_object('tactivo_anterior', _data_old.tactivo, 'tactivo_nuevo', _data_new.tactivo)::jsonb;
			END IF;
			IF _data_old.id_user <> _data_new.id_user
				THEN _datos := _datos || json_build_object('id_user_anterior', _data_old.id_user, 'id_user_nuevo', _data_new.id_user)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'usuarios',
			'token',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;


ALTER FUNCTION security.field_audit(_data_new usuarios.token, _data_old usuarios.token, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) OWNER TO postgres;

--
-- Name: usuarios; Type: TABLE; Schema: usuarios; Owner: postgres
--

CREATE TABLE usuarios.usuarios (
    id integer NOT NULL,
    nombre text NOT NULL,
    apellido text NOT NULL,
    email text NOT NULL,
    usuario text NOT NULL,
    id_rol integer NOT NULL,
    session text DEFAULT 'sistema'::text NOT NULL,
    modified_by time without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "contraseña" text NOT NULL,
    telefono text NOT NULL,
    activo integer NOT NULL,
    validado boolean DEFAULT false NOT NULL
);


ALTER TABLE usuarios.usuarios OWNER TO postgres;

--
-- Name: field_audit(usuarios.usuarios, usuarios.usuarios, character varying, text, character varying, text, text); Type: FUNCTION; Schema: security; Owner: postgres
--

CREATE FUNCTION security.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) RETURNS text
    LANGUAGE plpgsql
    AS $$

	DECLARE
		_column_data TEXT;
	 	_datos jsonb;
	 	
	BEGIN
			_datos = '{}';

		IF _accion = 'INSERT'
			THEN
				_datos := _datos || json_build_object('id_nuevo', _data_new.id)::jsonb;
				_datos := _datos || json_build_object('nombre_nuevo', _data_new.nombre)::jsonb;
				_datos := _datos || json_build_object('apellido_nuevo', _data_new.apellido)::jsonb;
				_datos := _datos || json_build_object('email_nuevo', _data_new.email)::jsonb;
				_datos := _datos || json_build_object('usuario_nuevo', _data_new.usuario)::jsonb;
				_datos := _datos || json_build_object('id_rol_nuevo', _data_new.id_rol)::jsonb;
				_datos := _datos || json_build_object('session_nuevo', _data_new.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_nuevo', _data_new.modified_by)::jsonb;
				_datos := _datos || json_build_object('contraseña_nuevo', _data_new.contraseña)::jsonb;
				_datos := _datos || json_build_object('telefono_nuevo', _data_new.telefono)::jsonb;
				_datos := _datos || json_build_object('activo_nuevo', _data_new.activo)::jsonb;
				_datos := _datos || json_build_object('validado_nuevo', _data_new.validado)::jsonb;
				
		ELSEIF _accion = 'DELETE'
			THEN
				_datos := _datos || json_build_object('id_anterior', _data_old.id)::jsonb;
				_datos := _datos || json_build_object('nombre_anterior', _data_old.nombre)::jsonb;
				_datos := _datos || json_build_object('apellido_anterior', _data_old.apellido)::jsonb;
				_datos := _datos || json_build_object('email_anterior', _data_old.email)::jsonb;
				_datos := _datos || json_build_object('usuario_anterior', _data_old.usuario)::jsonb;
				_datos := _datos || json_build_object('id_rol_anterior', _data_old.id_rol)::jsonb;
				_datos := _datos || json_build_object('session_anterior', _data_old.session)::jsonb;
				_datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by)::jsonb;
				_datos := _datos || json_build_object('contraseña_anterior', _data_old.contraseña)::jsonb;
				_datos := _datos || json_build_object('telefono_anterior', _data_old.telefono)::jsonb;
				_datos := _datos || json_build_object('activo_anterior', _data_old.activo)::jsonb;
				_datos := _datos || json_build_object('validado_anterior', _data_old.validado)::jsonb;
				
		ELSE
			IF _data_old.id <> _data_new.id
				THEN _datos := _datos || json_build_object('id_anterior', _data_old.id, 'id_nuevo', _data_new.id)::jsonb;
			END IF;
			IF _data_old.nombre <> _data_new.nombre
				THEN _datos := _datos || json_build_object('nombre_anterior', _data_old.nombre, 'nombre_nuevo', _data_new.nombre)::jsonb;
			END IF;
			IF _data_old.apellido <> _data_new.apellido
				THEN _datos := _datos || json_build_object('apellido_anterior', _data_old.apellido, 'apellido_nuevo', _data_new.apellido)::jsonb;
			END IF;
			IF _data_old.email <> _data_new.email
				THEN _datos := _datos || json_build_object('email_anterior', _data_old.email, 'email_nuevo', _data_new.email)::jsonb;
			END IF;
			IF _data_old.usuario <> _data_new.usuario
				THEN _datos := _datos || json_build_object('usuario_anterior', _data_old.usuario, 'usuario_nuevo', _data_new.usuario)::jsonb;
			END IF;
			IF _data_old.id_rol <> _data_new.id_rol
				THEN _datos := _datos || json_build_object('id_rol_anterior', _data_old.id_rol, 'id_rol_nuevo', _data_new.id_rol)::jsonb;
			END IF;
			IF _data_old.session <> _data_new.session
				THEN _datos := _datos || json_build_object('session_anterior', _data_old.session, 'session_nuevo', _data_new.session)::jsonb;
			END IF;
			IF _data_old.modified_by <> _data_new.modified_by
				THEN _datos := _datos || json_build_object('modified_by_anterior', _data_old.modified_by, 'modified_by_nuevo', _data_new.modified_by)::jsonb;
			END IF;
			IF _data_old.contraseña <> _data_new.contraseña
				THEN _datos := _datos || json_build_object('contraseña_anterior', _data_old.contraseña, 'contraseña_nuevo', _data_new.contraseña)::jsonb;
			END IF;
			IF _data_old.telefono <> _data_new.telefono
				THEN _datos := _datos || json_build_object('telefono_anterior', _data_old.telefono, 'telefono_nuevo', _data_new.telefono)::jsonb;
			END IF;
			IF _data_old.activo <> _data_new.activo
				THEN _datos := _datos || json_build_object('activo_anterior', _data_old.activo, 'activo_nuevo', _data_new.activo)::jsonb;
			END IF;
			IF _data_old.validado <> _data_new.validado
				THEN _datos := _datos || json_build_object('validado_anterior', _data_old.validado, 'validado_nuevo', _data_new.validado)::jsonb;
			END IF;
			 
		END IF;

		INSERT INTO security.auditoria
		(
			fecha,
			accion,
			schema,
			tabla,
			pk,
			session,
			user_bd,
			data
		)
		VALUES
		(
			CURRENT_TIMESTAMP,
			_accion,
			'usuarios',
			'usuarios',
			_table_pk,
			_session,
			_user_db,
			_datos::jsonb
			);

		RETURN NULL; 
	END;$$;


ALTER FUNCTION security.field_audit(_data_new usuarios.usuarios, _data_old usuarios.usuarios, _accion character varying, _session text, _user_db character varying, _table_pk text, _init text) OWNER TO postgres;

--
-- Name: PQRS_id_seq; Type: SEQUENCE; Schema: publicaciones; Owner: postgres
--

CREATE SEQUENCE publicaciones."PQRS_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE publicaciones."PQRS_id_seq" OWNER TO postgres;

--
-- Name: PQRS_id_seq; Type: SEQUENCE OWNED BY; Schema: publicaciones; Owner: postgres
--

ALTER SEQUENCE publicaciones."PQRS_id_seq" OWNED BY publicaciones.pqrs.id;


--
-- Name: historico_subastas_id_seq; Type: SEQUENCE; Schema: publicaciones; Owner: postgres
--

CREATE SEQUENCE publicaciones.historico_subastas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE publicaciones.historico_subastas_id_seq OWNER TO postgres;

--
-- Name: historico_subastas_id_seq; Type: SEQUENCE OWNED BY; Schema: publicaciones; Owner: postgres
--

ALTER SEQUENCE publicaciones.historico_subastas_id_seq OWNED BY publicaciones.historico_subastas.id;


--
-- Name: inventario_id_seq; Type: SEQUENCE; Schema: publicaciones; Owner: postgres
--

CREATE SEQUENCE publicaciones.inventario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE publicaciones.inventario_id_seq OWNER TO postgres;

--
-- Name: inventario_id_seq; Type: SEQUENCE OWNED BY; Schema: publicaciones; Owner: postgres
--

ALTER SEQUENCE publicaciones.inventario_id_seq OWNED BY publicaciones.inventario.id;


--
-- Name: piniones_id_seq; Type: SEQUENCE; Schema: publicaciones; Owner: postgres
--

CREATE SEQUENCE publicaciones.piniones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE publicaciones.piniones_id_seq OWNER TO postgres;

--
-- Name: piniones_id_seq; Type: SEQUENCE OWNED BY; Schema: publicaciones; Owner: postgres
--

ALTER SEQUENCE publicaciones.piniones_id_seq OWNED BY publicaciones.piniones.id;


--
-- Name: subasta_id_seq; Type: SEQUENCE; Schema: publicaciones; Owner: postgres
--

CREATE SEQUENCE publicaciones.subasta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE publicaciones.subasta_id_seq OWNER TO postgres;

--
-- Name: subasta_id_seq; Type: SEQUENCE OWNED BY; Schema: publicaciones; Owner: postgres
--

ALTER SEQUENCE publicaciones.subasta_id_seq OWNED BY publicaciones.subasta.id;


--
-- Name: talla; Type: TABLE; Schema: publicaciones; Owner: postgres
--

CREATE TABLE publicaciones.talla (
    id integer NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE publicaciones.talla OWNER TO postgres;

--
-- Name: talla_id_seq; Type: SEQUENCE; Schema: publicaciones; Owner: postgres
--

CREATE SEQUENCE publicaciones.talla_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE publicaciones.talla_id_seq OWNER TO postgres;

--
-- Name: talla_id_seq; Type: SEQUENCE OWNED BY; Schema: publicaciones; Owner: postgres
--

ALTER SEQUENCE publicaciones.talla_id_seq OWNED BY publicaciones.talla.id;


--
-- Name: tipo_bicicleta_id_seq; Type: SEQUENCE; Schema: publicaciones; Owner: postgres
--

CREATE SEQUENCE publicaciones.tipo_bicicleta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE publicaciones.tipo_bicicleta_id_seq OWNER TO postgres;

--
-- Name: tipo_bicicleta_id_seq; Type: SEQUENCE OWNED BY; Schema: publicaciones; Owner: postgres
--

ALTER SEQUENCE publicaciones.tipo_bicicleta_id_seq OWNED BY publicaciones.tipo_bicicleta.id;


--
-- Name: tipo_frenos; Type: TABLE; Schema: publicaciones; Owner: postgres
--

CREATE TABLE publicaciones.tipo_frenos (
    id integer NOT NULL,
    descripcion text NOT NULL
);


ALTER TABLE publicaciones.tipo_frenos OWNER TO postgres;

--
-- Name: tipo_frenos_id_seq; Type: SEQUENCE; Schema: publicaciones; Owner: postgres
--

CREATE SEQUENCE publicaciones.tipo_frenos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE publicaciones.tipo_frenos_id_seq OWNER TO postgres;

--
-- Name: tipo_frenos_id_seq; Type: SEQUENCE OWNED BY; Schema: publicaciones; Owner: postgres
--

ALTER SEQUENCE publicaciones.tipo_frenos_id_seq OWNED BY publicaciones.tipo_frenos.id;


--
-- Name: auditoria; Type: TABLE; Schema: security; Owner: postgres
--

CREATE TABLE security.auditoria (
    id integer NOT NULL,
    fecha timestamp without time zone NOT NULL,
    accion character varying(100),
    schema character varying(200) NOT NULL,
    tabla character varying(200),
    session text NOT NULL,
    user_bd character varying(100) NOT NULL,
    data jsonb NOT NULL,
    pk text NOT NULL
);


ALTER TABLE security.auditoria OWNER TO postgres;

--
-- Name: TABLE auditoria; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON TABLE security.auditoria IS 'Tabla que almacena la trazabilidad de la informaicón.';


--
-- Name: COLUMN auditoria.id; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON COLUMN security.auditoria.id IS 'campo pk de la tabla ';


--
-- Name: COLUMN auditoria.fecha; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON COLUMN security.auditoria.fecha IS 'ALmacen ala la fecha de la modificación';


--
-- Name: COLUMN auditoria.accion; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON COLUMN security.auditoria.accion IS 'Almacena la accion que se ejecuto sobre el registro';


--
-- Name: COLUMN auditoria.schema; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON COLUMN security.auditoria.schema IS 'Almanena el nomnbre del schema de la tabla que se modifico';


--
-- Name: COLUMN auditoria.tabla; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON COLUMN security.auditoria.tabla IS 'Almacena el nombre de la tabla que se modifico';


--
-- Name: COLUMN auditoria.session; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON COLUMN security.auditoria.session IS 'Campo que almacena el id de la session que generó el cambio';


--
-- Name: COLUMN auditoria.user_bd; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON COLUMN security.auditoria.user_bd IS 'Campo que almacena el user que se autentico en el motor para generar el cmabio';


--
-- Name: COLUMN auditoria.data; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON COLUMN security.auditoria.data IS 'campo que almacena la modificaicón que se realizó';


--
-- Name: COLUMN auditoria.pk; Type: COMMENT; Schema: security; Owner: postgres
--

COMMENT ON COLUMN security.auditoria.pk IS 'Campo que identifica el id del registro.';


--
-- Name: auditoria_id_seq; Type: SEQUENCE; Schema: security; Owner: postgres
--

CREATE SEQUENCE security.auditoria_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE security.auditoria_id_seq OWNER TO postgres;

--
-- Name: auditoria_id_seq; Type: SEQUENCE OWNED BY; Schema: security; Owner: postgres
--

ALTER SEQUENCE security.auditoria_id_seq OWNED BY security.auditoria.id;


--
-- Name: function_db_view; Type: VIEW; Schema: security; Owner: postgres
--

CREATE VIEW security.function_db_view AS
 SELECT pp.proname AS b_function,
    oidvectortypes(pp.proargtypes) AS b_type_parameters
   FROM (pg_proc pp
     JOIN pg_namespace pn ON ((pn.oid = pp.pronamespace)))
  WHERE ((pn.nspname)::text <> ALL (ARRAY[('pg_catalog'::character varying)::text, ('information_schema'::character varying)::text, ('admin_control'::character varying)::text, ('vial'::character varying)::text]));


ALTER TABLE security.function_db_view OWNER TO postgres;

--
-- Name: rol_id_seq; Type: SEQUENCE; Schema: usuarios; Owner: postgres
--

CREATE SEQUENCE usuarios.rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE usuarios.rol_id_seq OWNER TO postgres;

--
-- Name: rol_id_seq; Type: SEQUENCE OWNED BY; Schema: usuarios; Owner: postgres
--

ALTER SEQUENCE usuarios.rol_id_seq OWNED BY usuarios.rol.id;


--
-- Name: token_id_seq; Type: SEQUENCE; Schema: usuarios; Owner: postgres
--

CREATE SEQUENCE usuarios.token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE usuarios.token_id_seq OWNER TO postgres;

--
-- Name: token_id_seq; Type: SEQUENCE OWNED BY; Schema: usuarios; Owner: postgres
--

ALTER SEQUENCE usuarios.token_id_seq OWNED BY usuarios.token.id;


--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: usuarios; Owner: postgres
--

CREATE SEQUENCE usuarios.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE usuarios.usuarios_id_seq OWNER TO postgres;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: usuarios; Owner: postgres
--

ALTER SEQUENCE usuarios.usuarios_id_seq OWNED BY usuarios.usuarios.id;


--
-- Name: historico_subastas id; Type: DEFAULT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.historico_subastas ALTER COLUMN id SET DEFAULT nextval('publicaciones.historico_subastas_id_seq'::regclass);


--
-- Name: inventario id; Type: DEFAULT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.inventario ALTER COLUMN id SET DEFAULT nextval('publicaciones.inventario_id_seq'::regclass);


--
-- Name: piniones id; Type: DEFAULT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.piniones ALTER COLUMN id SET DEFAULT nextval('publicaciones.piniones_id_seq'::regclass);


--
-- Name: pqrs id; Type: DEFAULT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.pqrs ALTER COLUMN id SET DEFAULT nextval('publicaciones."PQRS_id_seq"'::regclass);


--
-- Name: subasta id; Type: DEFAULT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.subasta ALTER COLUMN id SET DEFAULT nextval('publicaciones.subasta_id_seq'::regclass);


--
-- Name: talla id; Type: DEFAULT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.talla ALTER COLUMN id SET DEFAULT nextval('publicaciones.talla_id_seq'::regclass);


--
-- Name: tipo_bicicleta id; Type: DEFAULT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.tipo_bicicleta ALTER COLUMN id SET DEFAULT nextval('publicaciones.tipo_bicicleta_id_seq'::regclass);


--
-- Name: tipo_frenos id; Type: DEFAULT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.tipo_frenos ALTER COLUMN id SET DEFAULT nextval('publicaciones.tipo_frenos_id_seq'::regclass);


--
-- Name: auditoria id; Type: DEFAULT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.auditoria ALTER COLUMN id SET DEFAULT nextval('security.auditoria_id_seq'::regclass);


--
-- Name: rol id; Type: DEFAULT; Schema: usuarios; Owner: postgres
--

ALTER TABLE ONLY usuarios.rol ALTER COLUMN id SET DEFAULT nextval('usuarios.rol_id_seq'::regclass);


--
-- Name: token id; Type: DEFAULT; Schema: usuarios; Owner: postgres
--

ALTER TABLE ONLY usuarios.token ALTER COLUMN id SET DEFAULT nextval('usuarios.token_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: usuarios; Owner: postgres
--

ALTER TABLE ONLY usuarios.usuarios ALTER COLUMN id SET DEFAULT nextval('usuarios.usuarios_id_seq'::regclass);


--
-- Data for Name: historico_subastas; Type: TABLE DATA; Schema: publicaciones; Owner: postgres
--

COPY publicaciones.historico_subastas (id, id_comprador, id_subasta, valor) FROM stdin;
\.
COPY publicaciones.historico_subastas (id, id_comprador, id_subasta, valor) FROM '$$PATH$$/3137.dat';

--
-- Data for Name: inventario; Type: TABLE DATA; Schema: publicaciones; Owner: postgres
--

COPY publicaciones.inventario (id, imagen1, imagen2, imagen3, precio, status, session, modified_by, talla, referencia, marca, id_vendedor, id_comprador, fecha_revicion, color, "año", ciudad, tipo_bicicleta, tipo_frenos, "n_piñones", correo) FROM stdin;
\.
COPY publicaciones.inventario (id, imagen1, imagen2, imagen3, precio, status, session, modified_by, talla, referencia, marca, id_vendedor, id_comprador, fecha_revicion, color, "año", ciudad, tipo_bicicleta, tipo_frenos, "n_piñones", correo) FROM '$$PATH$$/3138.dat';

--
-- Data for Name: piniones; Type: TABLE DATA; Schema: publicaciones; Owner: postgres
--

COPY publicaciones.piniones (id, descripcion) FROM stdin;
\.
COPY publicaciones.piniones (id, descripcion) FROM '$$PATH$$/3139.dat';

--
-- Data for Name: pqrs; Type: TABLE DATA; Schema: publicaciones; Owner: postgres
--

COPY publicaciones.pqrs (id, id_publicacion, id_cliente_reporto, descripcion, session, modified_by, status) FROM stdin;
\.
COPY publicaciones.pqrs (id, id_publicacion, id_cliente_reporto, descripcion, session, modified_by, status) FROM '$$PATH$$/3140.dat';

--
-- Data for Name: subasta; Type: TABLE DATA; Schema: publicaciones; Owner: postgres
--

COPY publicaciones.subasta (id, valor_inicial, status, puja_alta, id_producto, id_cliente, fecha_inicio, fecha_fin, modified_by, session, id_comprador, correo) FROM stdin;
\.
COPY publicaciones.subasta (id, valor_inicial, status, puja_alta, id_producto, id_cliente, fecha_inicio, fecha_fin, modified_by, session, id_comprador, correo) FROM '$$PATH$$/3141.dat';

--
-- Data for Name: talla; Type: TABLE DATA; Schema: publicaciones; Owner: postgres
--

COPY publicaciones.talla (id, descripcion) FROM stdin;
\.
COPY publicaciones.talla (id, descripcion) FROM '$$PATH$$/3151.dat';

--
-- Data for Name: tipo_bicicleta; Type: TABLE DATA; Schema: publicaciones; Owner: postgres
--

COPY publicaciones.tipo_bicicleta (id, descripcion) FROM stdin;
\.
COPY publicaciones.tipo_bicicleta (id, descripcion) FROM '$$PATH$$/3142.dat';

--
-- Data for Name: tipo_frenos; Type: TABLE DATA; Schema: publicaciones; Owner: postgres
--

COPY publicaciones.tipo_frenos (id, descripcion) FROM stdin;
\.
COPY publicaciones.tipo_frenos (id, descripcion) FROM '$$PATH$$/3154.dat';

--
-- Data for Name: auditoria; Type: TABLE DATA; Schema: security; Owner: postgres
--

COPY security.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM stdin;
\.
COPY security.auditoria (id, fecha, accion, schema, tabla, session, user_bd, data, pk) FROM '$$PATH$$/3156.dat';

--
-- Data for Name: rol; Type: TABLE DATA; Schema: usuarios; Owner: postgres
--

COPY usuarios.rol (id, desripcion, session, modified_by) FROM stdin;
\.
COPY usuarios.rol (id, desripcion, session, modified_by) FROM '$$PATH$$/3143.dat';

--
-- Data for Name: token; Type: TABLE DATA; Schema: usuarios; Owner: postgres
--

COPY usuarios.token (id, finicio, ffin, tactivo, id_user) FROM stdin;
\.
COPY usuarios.token (id, finicio, ffin, tactivo, id_user) FROM '$$PATH$$/3144.dat';

--
-- Data for Name: usuarios; Type: TABLE DATA; Schema: usuarios; Owner: postgres
--

COPY usuarios.usuarios (id, nombre, apellido, email, usuario, id_rol, session, modified_by, "contraseña", telefono, activo, validado) FROM stdin;
\.
COPY usuarios.usuarios (id, nombre, apellido, email, usuario, id_rol, session, modified_by, "contraseña", telefono, activo, validado) FROM '$$PATH$$/3145.dat';

--
-- Name: PQRS_id_seq; Type: SEQUENCE SET; Schema: publicaciones; Owner: postgres
--

SELECT pg_catalog.setval('publicaciones."PQRS_id_seq"', 5, true);


--
-- Name: historico_subastas_id_seq; Type: SEQUENCE SET; Schema: publicaciones; Owner: postgres
--

SELECT pg_catalog.setval('publicaciones.historico_subastas_id_seq', 6, true);


--
-- Name: inventario_id_seq; Type: SEQUENCE SET; Schema: publicaciones; Owner: postgres
--

SELECT pg_catalog.setval('publicaciones.inventario_id_seq', 19, true);


--
-- Name: piniones_id_seq; Type: SEQUENCE SET; Schema: publicaciones; Owner: postgres
--

SELECT pg_catalog.setval('publicaciones.piniones_id_seq', 13, true);


--
-- Name: subasta_id_seq; Type: SEQUENCE SET; Schema: publicaciones; Owner: postgres
--

SELECT pg_catalog.setval('publicaciones.subasta_id_seq', 5, true);


--
-- Name: talla_id_seq; Type: SEQUENCE SET; Schema: publicaciones; Owner: postgres
--

SELECT pg_catalog.setval('publicaciones.talla_id_seq', 5, true);


--
-- Name: tipo_bicicleta_id_seq; Type: SEQUENCE SET; Schema: publicaciones; Owner: postgres
--

SELECT pg_catalog.setval('publicaciones.tipo_bicicleta_id_seq', 8, true);


--
-- Name: tipo_frenos_id_seq; Type: SEQUENCE SET; Schema: publicaciones; Owner: postgres
--

SELECT pg_catalog.setval('publicaciones.tipo_frenos_id_seq', 3, true);


--
-- Name: auditoria_id_seq; Type: SEQUENCE SET; Schema: security; Owner: postgres
--

SELECT pg_catalog.setval('security.auditoria_id_seq', 154, true);


--
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: usuarios; Owner: postgres
--

SELECT pg_catalog.setval('usuarios.rol_id_seq', 3, true);


--
-- Name: token_id_seq; Type: SEQUENCE SET; Schema: usuarios; Owner: postgres
--

SELECT pg_catalog.setval('usuarios.token_id_seq', 12, true);


--
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: usuarios; Owner: postgres
--

SELECT pg_catalog.setval('usuarios.usuarios_id_seq', 5, true);


--
-- Name: pqrs PQRS_pkey; Type: CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.pqrs
    ADD CONSTRAINT "PQRS_pkey" PRIMARY KEY (id);


--
-- Name: piniones piniones_pkey; Type: CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.piniones
    ADD CONSTRAINT piniones_pkey PRIMARY KEY (id);


--
-- Name: historico_subastas pk_publicaciones_historico; Type: CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.historico_subastas
    ADD CONSTRAINT pk_publicaciones_historico PRIMARY KEY (id);


--
-- Name: inventario pk_publicaciones_inventario; Type: CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.inventario
    ADD CONSTRAINT pk_publicaciones_inventario PRIMARY KEY (id);


--
-- Name: tipo_bicicleta pk_publicaciones_tipo_bicicleta; Type: CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.tipo_bicicleta
    ADD CONSTRAINT pk_publicaciones_tipo_bicicleta PRIMARY KEY (id);


--
-- Name: tipo_frenos pk_publicaciones_tipo_frenos; Type: CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.tipo_frenos
    ADD CONSTRAINT pk_publicaciones_tipo_frenos PRIMARY KEY (id);


--
-- Name: subasta subasta_pkey; Type: CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.subasta
    ADD CONSTRAINT subasta_pkey PRIMARY KEY (id);


--
-- Name: talla talla_pkey; Type: CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.talla
    ADD CONSTRAINT talla_pkey PRIMARY KEY (id);


--
-- Name: auditoria pk_security_auditoria; Type: CONSTRAINT; Schema: security; Owner: postgres
--

ALTER TABLE ONLY security.auditoria
    ADD CONSTRAINT pk_security_auditoria PRIMARY KEY (id);


--
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: usuarios; Owner: postgres
--

ALTER TABLE ONLY usuarios.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- Name: token token_pkey; Type: CONSTRAINT; Schema: usuarios; Owner: postgres
--

ALTER TABLE ONLY usuarios.token
    ADD CONSTRAINT token_pkey PRIMARY KEY (id);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: usuarios; Owner: postgres
--

ALTER TABLE ONLY usuarios.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: historico_subastas tg_publicaciones_historico_subastas; Type: TRIGGER; Schema: publicaciones; Owner: postgres
--

CREATE TRIGGER tg_publicaciones_historico_subastas AFTER INSERT OR DELETE OR UPDATE ON publicaciones.historico_subastas FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: inventario tg_publicaciones_inventario; Type: TRIGGER; Schema: publicaciones; Owner: postgres
--

CREATE TRIGGER tg_publicaciones_inventario AFTER INSERT OR DELETE OR UPDATE ON publicaciones.inventario FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: piniones tg_publicaciones_piniones; Type: TRIGGER; Schema: publicaciones; Owner: postgres
--

CREATE TRIGGER tg_publicaciones_piniones AFTER INSERT OR DELETE OR UPDATE ON publicaciones.piniones FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: pqrs tg_publicaciones_pqrs; Type: TRIGGER; Schema: publicaciones; Owner: postgres
--

CREATE TRIGGER tg_publicaciones_pqrs AFTER INSERT OR DELETE OR UPDATE ON publicaciones.pqrs FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: subasta tg_publicaciones_subasta; Type: TRIGGER; Schema: publicaciones; Owner: postgres
--

CREATE TRIGGER tg_publicaciones_subasta AFTER INSERT OR DELETE OR UPDATE ON publicaciones.subasta FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: talla tg_publicaciones_talla; Type: TRIGGER; Schema: publicaciones; Owner: postgres
--

CREATE TRIGGER tg_publicaciones_talla AFTER INSERT OR DELETE OR UPDATE ON publicaciones.talla FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: tipo_bicicleta tg_publicaciones_tipo_bicicleta; Type: TRIGGER; Schema: publicaciones; Owner: postgres
--

CREATE TRIGGER tg_publicaciones_tipo_bicicleta AFTER INSERT OR DELETE OR UPDATE ON publicaciones.tipo_bicicleta FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: tipo_frenos tg_publicaciones_tipo_frenos; Type: TRIGGER; Schema: publicaciones; Owner: postgres
--

CREATE TRIGGER tg_publicaciones_tipo_frenos AFTER INSERT OR DELETE OR UPDATE ON publicaciones.tipo_frenos FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: rol tg_usuarios_rol; Type: TRIGGER; Schema: usuarios; Owner: postgres
--

CREATE TRIGGER tg_usuarios_rol AFTER INSERT OR DELETE OR UPDATE ON usuarios.rol FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: token tg_usuarios_token; Type: TRIGGER; Schema: usuarios; Owner: postgres
--

CREATE TRIGGER tg_usuarios_token AFTER INSERT OR DELETE OR UPDATE ON usuarios.token FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: usuarios tg_usuarios_usuarios; Type: TRIGGER; Schema: usuarios; Owner: postgres
--

CREATE TRIGGER tg_usuarios_usuarios AFTER INSERT OR DELETE OR UPDATE ON usuarios.usuarios FOR EACH ROW EXECUTE FUNCTION security.f_log_auditoria();


--
-- Name: historico_subastas FK_publicaciones_subasta; Type: FK CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.historico_subastas
    ADD CONSTRAINT "FK_publicaciones_subasta" FOREIGN KEY (id_subasta) REFERENCES publicaciones.subasta(id);


--
-- Name: historico_subastas FK_usuarios_usuarios; Type: FK CONSTRAINT; Schema: publicaciones; Owner: postgres
--

ALTER TABLE ONLY publicaciones.historico_subastas
    ADD CONSTRAINT "FK_usuarios_usuarios" FOREIGN KEY (id_comprador) REFERENCES usuarios.usuarios(id);


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 