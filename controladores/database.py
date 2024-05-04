from os import getenv
from psycopg2 import sql
from psycopg2.extras import execute_values
from psycopg2 import connect, DatabaseError

class DataBase:
    def __init__(self):
        self.host = getenv("DB_HOST")
        self.port = getenv("DB_PORT")
        self.database = getenv("DB_NAME")
        self.user = getenv("DB_USER")
        self.password = getenv("DB_PASSWORD")
        self.schema = getenv("DB_SCHEMA")

    def ejecutar_consulta(self, consulta, valores):
        conn = connect(
            host=self.host,
            port=self.port,
            database=self.database,
            user=self.user,
            password=self.password,
            options=f'-c search_path={self.schema}'
        )
        cursor = conn.cursor()
        try:
            
            cursor.execute(consulta, valores)
            resultados = cursor.fetchall()
            return resultados
        except (Exception, DatabaseError) as error:
            raise ValueError(error)
        finally:
            cursor.close()
            conn.close()

    def ejecutar_operacion(self, operacion, valores):
        conn = connect(
            host=self.host,
            port=self.port,
            database=self.database,
            user=self.user,
            password=self.password,
            options=f'-c search_path={self.schema}'
        )
        cursor = conn.cursor()
        try:
            upsert_query = sql.SQL(operacion)
            execute_values(cursor, upsert_query, valores)
            conn.commit()
            return "Operacion ejecutada correctamente"
        except (Exception, DatabaseError) as error:
            conn.rollback()
            raise ValueError(error)
        finally:
            cursor.close()
            conn.close()

    def executemany_operation(self, consulta, values):
        conn = connect(
            host=self.host,
            port=self.port,
            database=self.database,
            user=self.user,
            password=self.password,
            options=f'-c search_path={self.schema}'
        )
        cursor = conn.cursor()
        try:
            cursor.executemany(consulta, values)
            conn.commit()
            return "Operacion ejecutada correctamente"
        except (Exception, DatabaseError) as error:
            conn.rollback()
            raise ValueError(error)
        finally:
            cursor.close()
            conn.close()
        
    def ejecutar_op(self, consulta, values):
        conn = connect(
            host=self.host,
            port=self.port,
            database=self.database,
            user=self.user,
            password=self.password,
            options=f'-c search_path={self.schema}'
        )
        cursor = conn.cursor()
        try:
            cursor.execute(consulta, values)
            conn.commit()
        except (Exception, DatabaseError) as error:
            conn.rollback()
            raise ValueError(error)
        finally:
            cursor.close()
            conn.close()