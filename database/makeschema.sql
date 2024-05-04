CREATE EXTENSION IF NOT EXISTS pgcrypto;
DROP TABLE IF EXISTS metodos;
DROP TABLE IF EXISTS fechas_metodos;
DROP TABLE IF EXISTS gastos;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS pagos;

CREATE TABLE metodos (
	id serial,
	nombre varchar(50) NOT NULL,
	limite float,
	diaCorte int,
	periodoPago int,
	CONSTRAINT metodos_pkey PRIMARY KEY (id),
	CONSTRAINT unicos_metodos UNIQUE (nombre, limite)
);
CREATE INDEX ind_diaCorte_metodos ON metodos USING btree (diaCorte);
CREATE INDEX ind_nombre_metodos ON metodos USING btree (nombre);

CREATE TABLE cuadres (
	id serial,
	nombre varchar(50) NOT NULL,
	diaCuadre float NOT NULL,
	CONSTRAINT cuadres_pkey PRIMARY KEY (id),
	CONSTRAINT unicos_cuadres UNIQUE (nombre, dia_cuadre)
);
CREATE INDEX ind_nombre_cuadres ON cuadres USING btree (nombre);
CREATE INDEX ind_diaCuadre_metodos ON cuadres USING btree (diaCuadre);

CREATE TABLE fechasMetodos (
	id serial,
	idMetodo int NOT NULL,
    iniCorte date not null
    finCorte date not null,
    fechaPago date not null
	CONSTRAINT fechasMetodos_pkey PRIMARY KEY (id),
	CONSTRAINT unicos_fechasMetodos UNIQUE (idMetodo, iniCorte,finCorte, fechaPago),
    CONSTRAINT metodos_fechasMetodos FOREIGN KEY (idMetodo) REFERENCES metodos(id)
);
CREATE INDEX ind_iniCorte_fechasMetodos ON fechasMetodos USING btree (iniCorte);
CREATE INDEX ind_finCorte_fechasMetodos ON fechasMetodos USING btree (finCorte);
CREATE INDEX ind_fechaPago_fechasMetodos ON fechasMetodos USING btree (fechaPago);

CREATE TABLE fechasCuadres (
	id serial,
	idCuadre int NOT NULL,
    iniCorte date not null
    finCorte date not null,
    fechaPago date not null
	CONSTRAINT fechasCuadres_pkey PRIMARY KEY (id),
	CONSTRAINT unicos_fechasCuadres UNIQUE (idCuadre, iniCorte,finCorte, fechaPago),
    CONSTRAINT cuadres_fechasCuadres FOREIGN KEY (idCuadre) REFERENCES cuadres(id)
);
CREATE INDEX ind_iniCorte_fechasCuadres ON fechasCuadres USING btree (iniCorte);
CREATE INDEX ind_finCorte_fechasCuadres ON fechasCuadres USING btree (finCorte);
CREATE INDEX ind_fechaPago_fechasCuadres ON fechasCuadres USING btree (fechaPago);

CREATE TABLE categorias(
    id serial4,
    categoria varchar(100) NOT NULL,
    tipo varchar(50) NOT NULL,
    CONSTRAINT categorias_pkey PRIMARY KEY (id),
    CONSTRAINT unicos_categorias UNIQUE (categoria,tipo)
);
CREATE INDEX ind_tipo_categorias ON categorias USING btree (tipo);

CREATE TABLE planeacion(
    id serial,
    año int,
    mes varchar(16),
    subcategoria varchar(100),
    idCategoria int,
    montoPlaneadoMensual float,
    CONSTRAINT planeacion_pkey PRIMAY KEY (id),
    CONSTRAINT unicos_planeacion UNIQUE (año, mes, subcategoria, id_Categoria),
    CONSTRAINT categorias_planeacion FOREIGN KEY (idCategoria) REFERENCES categorias(id)
);
CREATE INDEX ind_subcategoria_planeacion ON planeacion USING btree (subcategoria);
CREATE INDEX ind_subcategoria_año ON planeacion USING btree (año);
CREATE INDEX ind_subcategoria_mes ON planeacion USING btree (mes);

CREATE TABLE gastos (
	id serial,
	fecha date NOT NULL,
	concepto varchar(100),
	idMetodo int NOT NULL,
	monto float NOT NULL,
	montoMio float,
	montoCuadre float,
	idCuadre int,
	idSubcategoria int,
	CONSTRAINT gastos_pkey PRIMARY KEY (id),
	CONSTRAINT unicos_gastos UNIQUE (fecha, concepto, idMetodo,monto,subcategoria),
	CONSTRAINT metodo_gastos FOREIGN KEY (idMetodo) REFERENCES metodos(id),
    CONSTRAINT cuadre_gastos FOREIGN KEY (idCuadre) REFERENCES cuadres(id)
);
CREATE INDEX ind_idCuadre_gastos ON gastos USING btree (idCuadre);
CREATE INDEX ind_idSubcategoria_gastos ON gastos USING btree (idSubcategoria);

CREATE TABLE pagosMetodos (
	id serial,
	nombre varchar(100) NOT NULL,
	idMetodoPorPagar int NOT NULL,
    idFechasMetodos int NOT NULL,
	fechaPagoReal date NOT NULL,     
	CONSTRAINT pagosMetodos_pkey PRIMARY KEY (id),
    CONSTRAINT unicos_pagosMetodos UNIQUE (nombre, idMetodoPorPagar, idFechasMetodos, fechaPagoReal),
    CONSTRAINT fechasMetodos_pagosMetodos FOREIGN KEY (idFechasMetodos) REFERENCES fechasMetodos(id),
    CONSTRAINT metodos_pagosMetodos FOREIGN KEY (idMetodoPorPagar) REFERENCES metodos(id)
);

CREATE TABLE pagosCuadres (
	id serial,
	nombre varchar(100) NOT NULL,
	idCuadrePorPagar int NOT NULL,
    idFechasCuadres int NOT NULL,
	fechaPagoReal date NOT NULL,     
	CONSTRAINT pagosCuadres_pkey PRIMARY KEY (id),
    CONSTRAINT unicos_pagosCuadres UNIQUE (nombre, idCuadrePorPagar, idFechasCuadres, fechaPagoReal),
    CONSTRAINT fechasCuadres_pagosCuadres FOREIGN KEY (idFechasCuadres) REFERENCES fechasCuadres(id),
    CONSTRAINT cuadres_pagosCuadres FOREIGN KEY (idCuadrePorPagar) REFERENCES cuadres(id)
);

CREATE TABLE ingresos(
    id serial,
    ente_ingreso varchar(50) NOT NULL,
    nombre varchar(50) NOT NULL,
    idMetodo int NOT NULL,
    monto float NOT NULL,
    quincenal bool NOT NULL DEFAULT false,
    CONSTRAINT ingresos_pkey PRIMAY KEY (id),
    CONSTRAINT unicos_ingresos UNIQUE (ente_ingreso,nombre,monto),
    CONSTRAINT metodos_ingresos FOREIGN KEY (idMetodo) REFERENCES metodos(id)
);
CREATE INDEX ind_quincenal_ingresos ON ingresos USING btree (quincenal);

CREATE TABLE cuentaCorriente(
    id serial,
    fecha date NOT NULL,
    concepto varchar(50) NOT NULL,
    abono bool NOT NULL default false,
    monto float NOT NULL,
    saldo float NOT NULL,
    hecho bool not null default false,
    CONSTRAINT cuentaCorriente_pkey PRIMARY KEY (id),
    CONSTRAINT unicos_cuentaCorriente UNIQUE (fecha,concepto,abono)
);
CREATE INDEX ind_fecha_cuentaCorriente ON cuentaCOrriente USING btree (fecha);

CREATE TABLE comprasMeses(
    id serial,
    concepto varchar(50) not null,
    monto float not null,
    meses int not null,
    fechaPrimerCorte date not null,
    montoMensual float not null,
    idMetodo int,
    idCuadre int,
    CONSTRAINT comprasMeses_pley PRIMARY KEY (id),
    CONSTRAINT unicos_comprasMeses UNIQUE (concepto, monto, meses, fechaPrimerCorte,idMetodo,idCuadre)
    CONSTRAINT metodos_comprasMeses FOREIGN KEY (idMetodo) REFERENCES metodos(id),
    CONSTRAINT cuadres_comprasMeses FOREIGN KEY (idCuadre) REFERENCES cuadres(id)
);
