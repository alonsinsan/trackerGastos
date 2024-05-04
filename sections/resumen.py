from streamlit import title, write
from controladores.querys import fetch_categorias, fetch_cuadres, fetch_fechasCuadres, fetch_fechasMetodos, fetch_gastos, fetch_metodos, fetch_subcategorias, insert_comprasMeses, insert_cuentaCorriente, insert_gastos, insert_pagosCuadres, insert_pagosMetodos, insert_planeacion

def main_resumen():
    '''
    Función que crea la sección de resumen
    '''
    title("Resumen mensual")
    write("Gasto por categoria")
    write("Gasto por subcategoria")
    write("Estatus cuenta corriente")
    