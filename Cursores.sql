
-- 1. Obtener el nombre de un cliente por ID
DECLARE
  v_nombre CLIENTES.NOMBRE%TYPE;
BEGIN
  SELECT NOMBRE INTO v_nombre
  FROM CLIENTES
  WHERE CLIENTE_ID = 1;
  DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_nombre);
END;


-- 2. Actualizar el estado de un pedido
BEGIN
  UPDATE PEDIDOS
  SET ESTADO = 'ENTREGADO'
  WHERE PEDIDO_ID = 5;
  DBMS_OUTPUT.PUT_LINE('Pedido actualizado');
END;


-- 3. Eliminar un producto inactivo
BEGIN
  DELETE FROM PRODUCTOS
  WHERE ACTIVO = 'NO';
  DBMS_OUTPUT.PUT_LINE('Producto eliminado');
END;


-- 4. Insertar un nuevo empleado
BEGIN
  INSERT INTO EMPLEADOS (NOMBRE, ROL, USUARIO, CONTRASENA)
  VALUES ('Carlos Pérez', 'Cajero', 'cperez', '1234');
  DBMS_OUTPUT.PUT_LINE('Empleado insertado');
END;


-- 5. Obtener el total de una factura
DECLARE
  v_total FACTURAS.TOTAL%TYPE;
BEGIN
  SELECT TOTAL INTO v_total
  FROM FACTURAS
  WHERE FACTURA_ID = 2;
  DBMS_OUTPUT.PUT_LINE('Total factura: ' || v_total);
END;



-- 6. Listar todos los clientes
DECLARE
  CURSOR c_clientes IS SELECT NOMBRE, CORREO FROM CLIENTES;
  v_nombre CLIENTES.NOMBRE%TYPE;
  v_correo CLIENTES.CORREO%TYPE;
BEGIN
  OPEN c_clientes;
  LOOP
    FETCH c_clientes INTO v_nombre, v_correo;
    EXIT WHEN c_clientes%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_nombre || ' - ' || v_correo);
  END LOOP;
  CLOSE c_clientes;
END;


-- 7. Listar empleados y su rol
DECLARE
  CURSOR c_empleados IS SELECT NOMBRE, ROL FROM EMPLEADOS;
  v_nombre EMPLEADOS.NOMBRE%TYPE;
  v_rol EMPLEADOS.ROL%TYPE;
BEGIN
  OPEN c_empleados;
  LOOP
    FETCH c_empleados INTO v_nombre, v_rol;
    EXIT WHEN c_empleados%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Empleado: ' || v_nombre || ' - Rol: ' || v_rol);
  END LOOP;
  CLOSE c_empleados;
END;


-- 8. Productos activos
DECLARE
  CURSOR c_productos IS SELECT NOMBRE, PRECIO FROM PRODUCTOS WHERE ACTIVO = 'SI';
  v_nombre PRODUCTOS.NOMBRE%TYPE;
  v_precio PRODUCTOS.PRECIO%TYPE;
BEGIN
  OPEN c_productos;
  LOOP
    FETCH c_productos INTO v_nombre, v_precio;
    EXIT WHEN c_productos%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Producto: ' || v_nombre || ' - Precio: ' || v_precio);
  END LOOP;
  CLOSE c_productos;
END;


-- 9. Inventario bajo stock
DECLARE
  CURSOR c_inventario IS SELECT PRODUCTO_ID, EXISTENCIAS FROM INVENTARIO WHERE EXISTENCIAS < STOCK_MINIMO;
  v_producto INVENTARIO.PRODUCTO_ID%TYPE;
  v_existencias INVENTARIO.EXISTENCIAS%TYPE;
BEGIN
  OPEN c_inventario;
  LOOP
    FETCH c_inventario INTO v_producto, v_existencias;
    EXIT WHEN c_inventario%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Producto ID: ' || v_producto || ' - Existencias: ' || v_existencias);
  END LOOP;
  CLOSE c_inventario;
END;


-- 10. Pedidos pendientes
DECLARE
  CURSOR c_pedidos IS SELECT PEDIDO_ID, ESTADO FROM PEDIDOS WHERE ESTADO = 'PENDIENTE';
  v_pedido PEDIDOS.PEDIDO_ID%TYPE;
  v_estado PEDIDOS.ESTADO%TYPE;
BEGIN
  OPEN c_pedidos;
  LOOP
    FETCH c_pedidos INTO v_pedido, v_estado;
    EXIT WHEN c_pedidos%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Pedido: ' || v_pedido || ' - Estado: ' || v_estado);
  END LOOP;
  CLOSE c_pedidos;
END;


-- 11. Detalle de pedidos
DECLARE
  CURSOR c_detalle IS SELECT PEDIDO_ID, PRODUCTO_ID, CANTIDAD FROM DETALLE_PEDIDO;
  v_pedido DETALLE_PEDIDO.PEDIDO_ID%TYPE;
  v_producto DETALLE_PEDIDO.PRODUCTO_ID%TYPE;
  v_cantidad DETALLE_PEDIDO.CANTIDAD%TYPE;
BEGIN
  OPEN c_detalle;
  LOOP
    FETCH c_detalle INTO v_pedido, v_producto, v_cantidad;
    EXIT WHEN c_detalle%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Pedido: ' || v_pedido || ' - Producto: ' || v_producto || ' - Cantidad: ' || v_cantidad);
  END LOOP;
  CLOSE c_detalle;
END;


-- 12. Facturas con descuento
DECLARE
  CURSOR c_facturas IS SELECT FACTURA_ID, TOTAL, DESCUENTO_APLICADO FROM FACTURAS WHERE DESCUENTO_APLICADO > 0;
  v_id FACTURAS.FACTURA_ID%TYPE;
  v_total FACTURAS.TOTAL%TYPE;
  v_desc FACTURAS.DESCUENTO_APLICADO%TYPE;
BEGIN
  OPEN c_facturas;
  LOOP
    FETCH c_facturas INTO v_id, v_total, v_desc;
    EXIT WHEN c_facturas%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Factura: ' || v_id || ' - Total: ' || v_total || ' - Descuento: ' || v_desc);
  END LOOP;
  CLOSE c_facturas;
END;


-- 13. Reportes de ventas
DECLARE
  CURSOR c_reportes IS SELECT REPORTE_ID, VENTAS_TOTALES FROM REPORTES;
  v_id REPORTES.REPORTE_ID%TYPE;
  v_ventas REPORTES.VENTAS_TOTALES%TYPE;
BEGIN
  OPEN c_reportes;
  LOOP
    FETCH c_reportes INTO v_id, v_ventas;
    EXIT WHEN c_reportes%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Reporte: ' || v_id || ' - Ventas: ' || v_ventas);
  END LOOP;
  CLOSE c_reportes;
END;


-- 14. Clientes con correo registrado
DECLARE
  CURSOR c_clientes_correo IS SELECT NOMBRE, CORREO FROM CLIENTES WHERE CORREO IS NOT NULL;
  v_nombre CLIENTES.NOMBRE%TYPE;
  v_correo CLIENTES.CORREO%TYPE;
BEGIN
  OPEN c_clientes_correo;
  LOOP
    FETCH c_clientes_correo INTO v_nombre, v_correo;
    EXIT WHEN c_clientes_correo%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Cliente: ' || v_nombre || ' - Correo: ' || v_correo);
  END LOOP;
  CLOSE c_clientes_correo;
END;


-- 15. Empleados por rol
DECLARE
  CURSOR c_empleados_rol IS SELECT NOMBRE, ROL FROM EMPLEADOS WHERE ROL = 'Cajero';
  v_nombre EMPLEADOS.NOMBRE%TYPE;
  v_rol EMPLEADOS.ROL%TYPE;
BEGIN
  OPEN c_empleados_rol;
  LOOP
    FETCH c_empleados_rol INTO v_nombre, v_rol;
    EXIT WHEN c_empleados_rol%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Empleado: ' || v_nombre || ' - Rol: ' || v_rol);
  END LOOP;
  CLOSE c_empleados_rol;
END;

