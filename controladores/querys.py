from dotenv import load_dotenv
from streamlit import session_state
from controladores.database import DataBase

load_dotenv()
db = DataBase()

def fetch_metodos():
    data = db.ejecutar_consulta(
        """
            select 
                *
            from metodos;
        """,
        ()
    )
    return data

def fetch_cuadres():
    data = db.ejecutar_consulta(
        """
            select 
                *
            from cuadres;
        """,
        ()
    )
    return data

def fetch_fechasMetodos(nombre):
    data = db.ejecutar_consulta(
        """
            select 
                m.nombre, f.iniCorte, f.finCorte, f.fechaPago
            from fechasMetodos f
            left join metodos m
            on
                f.idMetodo = m.id
            where
                m.nombre = %s
            ;
        """,
        (nombre)
    )
    return data

def fetch_fechasCuadres(nombre):
    data = db.ejecutar_consulta(
        """
            select 
                m.nombre, f.iniCorte, f.finCorte, f.fechaPago
            from fechasCuadres f
            left join cuadres c
            on
                f.idCuadre = c.id
            where
                c.nombre = %s
            ;
        """,
        (nombre)
    )
    return data

def fetch_categorias():
    data = db.ejecutar_consulta(
        """
            select 
                *
            from categorias;
        """,
        ()
    )
    return data

def fetch_subcategorias():
    data = db.ejecutar_consulta(
        """
            select 
                s.subcategoria, c.categoria, c.montoPlaneadoMensual
            from subcategorias s
            left join categorias c
            on
                s.idCategoria = c.id;
        """,
        ()
    )
    return data

def fetch_gastos(ini, fin):
    data = db.ejecutar_consulta(
        """
            select 
                g.fecha, g.concepto, m.nombre, 
            from gastos g
            left join metodos m
            on
                g.idMetodo = m.id
            left join cuadres c
            on
                g.idCuadre = c.id
            left join subcategorias s
            on
                g.idSubcategoria = s.id
            left join categorias ca
            on
                s.idCategoria = ca.id
            where
                g.fecha >= %s and
                g.fecha <= %s
        """,
        (ini, fin)
    )
    return data

def insert_gastos():
    a=1

def insert_comprasMeses():
    a = 1

def insert_cuentaCorriente():
    a=1

def insert_pagosCuadres():
    a=1

def insert_pagosMetodos():
    a=1

def insert_planeacion():
    a=1