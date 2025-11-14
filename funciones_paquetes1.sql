--------------------------------------------------------------------
-- PAQUETE: PKG_CLIENTES
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_CLIENTES IS

  FUNCTION f_total_pedidos_cliente (
    p_cliente_id IN NUMBER
  ) RETURN NUMBER;

  FUNCTION f_cliente_tiene_pedidos (
    p_cliente_id IN NUMBER
  ) RETURN NUMBER;

END PKG_CLIENTES;
/
CREATE OR REPLACE PACKAGE BODY PKG_CLIENTES IS

  FUNCTION f_total_pedidos_cliente (
    p_cliente_id IN NUMBER
  ) RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM PEDIDOS
    WHERE CLIENTE_ID = p_cliente_id;

    RETURN v_total;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_total_pedidos_cliente;


  FUNCTION f_cliente_tiene_pedidos (
    p_cliente_id IN NUMBER
  ) RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    v_total := f_total_pedidos_cliente(p_cliente_id);

    IF v_total > 0 THEN
      RETURN 1; -- sí tiene pedidos
    ELSE
      RETURN 0; -- no tiene pedidos
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_cliente_tiene_pedidos;

END PKG_CLIENTES;
/

--------------------------------------------------------------------
-- PAQUETE: PKG_EMPLEADOS
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_EMPLEADOS IS

  FUNCTION f_total_pedidos_empleado (
    p_empleado_id IN NUMBER
  ) RETURN NUMBER;

END PKG_EMPLEADOS;
/
CREATE OR REPLACE PACKAGE BODY PKG_EMPLEADOS IS

  FUNCTION f_total_pedidos_empleado (
    p_empleado_id IN NUMBER
  ) RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM PEDIDOS
    WHERE EMPLEADO_ID = p_empleado_id;

    RETURN v_total;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_total_pedidos_empleado;

END PKG_EMPLEADOS;
/

--------------------------------------------------------------------
-- PAQUETE: PKG_PRODUCTOS
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_PRODUCTOS IS

  FUNCTION f_es_producto_activo (
    p_producto_id IN NUMBER
  ) RETURN VARCHAR2;

  FUNCTION f_precio_producto (
    p_producto_id IN NUMBER
  ) RETURN NUMBER;

END PKG_PRODUCTOS;
/
CREATE OR REPLACE PACKAGE BODY PKG_PRODUCTOS IS

  FUNCTION f_es_producto_activo (
    p_producto_id IN NUMBER
  ) RETURN VARCHAR2 IS
    v_activo PRODUCTOS.ACTIVO%TYPE;
  BEGIN
    SELECT ACTIVO
    INTO v_activo
    FROM PRODUCTOS
    WHERE PRODUCTO_ID = p_producto_id;

    RETURN NVL(v_activo, 'N');
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'N';
    WHEN OTHERS THEN
      RETURN 'N';
  END f_es_producto_activo;


  FUNCTION f_precio_producto (
    p_producto_id IN NUMBER
  ) RETURN NUMBER IS
    v_precio PRODUCTOS.PRECIO%TYPE := 0;
  BEGIN
    SELECT PRECIO
    INTO v_precio
    FROM PRODUCTOS
    WHERE PRODUCTO_ID = p_producto_id;

    RETURN NVL(v_precio, 0);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
    WHEN OTHERS THEN
      RETURN 0;
  END f_precio_producto;

END PKG_PRODUCTOS;
/

--------------------------------------------------------------------
-- PAQUETE: PKG_INVENTARIO
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_INVENTARIO IS

  FUNCTION f_stock_actual (
    p_producto_id IN NUMBER
  ) RETURN NUMBER;

  FUNCTION f_productos_bajo_minimo RETURN NUMBER;

END PKG_INVENTARIO;
/
CREATE OR REPLACE PACKAGE BODY PKG_INVENTARIO IS

  FUNCTION f_stock_actual (
    p_producto_id IN NUMBER
  ) RETURN NUMBER IS
    v_stock NUMBER := 0;
  BEGIN
    SELECT EXISTENCIAS
    INTO v_stock
    FROM INVENTARIO
    WHERE PRODUCTO_ID = p_producto_id;

    RETURN NVL(v_stock, 0);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
    WHEN OTHERS THEN
      RETURN 0;
  END f_stock_actual;


  FUNCTION f_productos_bajo_minimo RETURN NUMBER IS
    v_cantidad NUMBER := 0;
  BEGIN
    SELECT COUNT(*)
    INTO v_cantidad
    FROM INVENTARIO
    WHERE EXISTENCIAS < STOCK_MINIMO;

    RETURN v_cantidad;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_productos_bajo_minimo;

END PKG_INVENTARIO;
/

--------------------------------------------------------------------
-- PAQUETE: PKG_PEDIDOS
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_PEDIDOS IS

  FUNCTION f_total_lineas_pedido (
    p_pedido_id IN NUMBER
  ) RETURN NUMBER;

  FUNCTION f_subtotal_pedido (
    p_pedido_id IN NUMBER
  ) RETURN NUMBER;

END PKG_PEDIDOS;
/
CREATE OR REPLACE PACKAGE BODY PKG_PEDIDOS IS

  FUNCTION f_total_lineas_pedido (
    p_pedido_id IN NUMBER
  ) RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    SELECT COUNT(*)
    INTO v_total
    FROM DETALLE_PEDIDO
    WHERE PEDIDO_ID = p_pedido_id;

    RETURN v_total;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_total_lineas_pedido;


  FUNCTION f_subtotal_pedido (
    p_pedido_id IN NUMBER
  ) RETURN NUMBER IS
    v_subtotal NUMBER := 0;
  BEGIN
    SELECT SUM(SUBTOTAL)
    INTO v_subtotal
    FROM DETALLE_PEDIDO
    WHERE PEDIDO_ID = p_pedido_id;

    RETURN NVL(v_subtotal, 0);
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_subtotal_pedido;

END PKG_PEDIDOS;
/

--------------------------------------------------------------------
-- PAQUETE: PKG_FACTURAS
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_FACTURAS IS

  FUNCTION f_total_facturas_cliente (
    p_cliente_id IN NUMBER
  ) RETURN NUMBER;

  FUNCTION f_total_facturado_fecha (
    p_fecha IN DATE
  ) RETURN NUMBER;

END PKG_FACTURAS;
/
CREATE OR REPLACE PACKAGE BODY PKG_FACTURAS IS

  FUNCTION f_total_facturas_cliente (
    p_cliente_id IN NUMBER
  ) RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    SELECT NVL(SUM(F.TOTAL), 0)
    INTO v_total
    FROM FACTURAS F
    JOIN PEDIDOS P ON F.PEDIDO_ID = P.PEDIDO_ID
    WHERE P.CLIENTE_ID = p_cliente_id;

    RETURN v_total;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_total_facturas_cliente;


  FUNCTION f_total_facturado_fecha (
    p_fecha IN DATE
  ) RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    SELECT NVL(SUM(TOTAL), 0)
    INTO v_total
    FROM FACTURAS
    WHERE TRUNC(FECHA) = TRUNC(p_fecha);

    RETURN v_total;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_total_facturado_fecha;

END PKG_FACTURAS;
/

--------------------------------------------------------------------
-- PAQUETE: PKG_DESCUENTOS
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_DESCUENTOS IS

  FUNCTION f_calcular_descuento (
    p_pedido_id IN NUMBER
  ) RETURN NUMBER;

END PKG_DESCUENTOS;
/
CREATE OR REPLACE PACKAGE BODY PKG_DESCUENTOS IS

  FUNCTION f_calcular_descuento (
    p_pedido_id IN NUMBER
  ) RETURN NUMBER IS
    v_subtotal NUMBER := 0;
    v_descuento NUMBER := 0;
  BEGIN
    v_subtotal := PKG_PEDIDOS.f_subtotal_pedido(p_pedido_id);

    -- Regla simple de ejemplo:
    -- Si el subtotal es mayor a 20000, 10% de descuento
    IF v_subtotal >= 20000 THEN
      v_descuento := v_subtotal * 0.10;
    ELSE
      v_descuento := 0;
    END IF;

    RETURN v_descuento;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_calcular_descuento;

END PKG_DESCUENTOS;
/

--------------------------------------------------------------------
-- PAQUETE: PKG_REPORTES
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_REPORTES IS

  FUNCTION f_ventas_por_producto (
    p_producto_id IN NUMBER
  ) RETURN NUMBER;

END PKG_REPORTES;
/
CREATE OR REPLACE PACKAGE BODY PKG_REPORTES IS

  FUNCTION f_ventas_por_producto (
    p_producto_id IN NUMBER
  ) RETURN NUMBER IS
    v_total NUMBER := 0;
  BEGIN
    SELECT NVL(SUM(D.CANTIDAD), 0)
    INTO v_total
    FROM DETALLE_PEDIDO D
    WHERE D.PRODUCTO_ID = p_producto_id;

    RETURN v_total;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_ventas_por_producto;

END PKG_REPORTES;
/

--------------------------------------------------------------------
-- PAQUETE: PKG_SEGURIDAD
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_SEGURIDAD IS

  FUNCTION f_validar_login (
    p_usuario    IN VARCHAR2,
    p_contrasena IN VARCHAR2
  ) RETURN NUMBER;

END PKG_SEGURIDAD;
/
CREATE OR REPLACE PACKAGE BODY PKG_SEGURIDAD IS

  FUNCTION f_validar_login (
    p_usuario    IN VARCHAR2,
    p_contrasena IN VARCHAR2
  ) RETURN NUMBER IS
    v_contador NUMBER := 0;
  BEGIN
    SELECT COUNT(*)
    INTO v_contador
    FROM EMPLEADOS
    WHERE USUARIO = p_usuario
      AND CONTRASENA = p_contrasena;

    IF v_contador = 1 THEN
      RETURN 1; -- credenciales válidas
    ELSE
      RETURN 0; -- inválidas
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_validar_login;

END PKG_SEGURIDAD;
/

--------------------------------------------------------------------
-- PAQUETE: PKG_UTILIDADES
--------------------------------------------------------------------
CREATE OR REPLACE PACKAGE PKG_UTILIDADES IS

  FUNCTION f_calcular_impuesto (
    p_monto IN NUMBER
  ) RETURN NUMBER;

END PKG_UTILIDADES;
/
CREATE OR REPLACE PACKAGE BODY PKG_UTILIDADES IS

  FUNCTION f_calcular_impuesto (
    p_monto IN NUMBER
  ) RETURN NUMBER IS
    c_impuesto CONSTANT NUMBER := 0.13; -- 13%
  BEGIN
    RETURN NVL(p_monto, 0) * c_impuesto;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 0;
  END f_calcular_impuesto;

END PKG_UTILIDADES;
/
