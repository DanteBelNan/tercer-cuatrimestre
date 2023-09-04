Select C.Apellidos, C.Nombres, C.Direccion, L.Nombre as Localidad, P.Nombre as Provincia From Localidades L
Left Join Clientes C on C.IDLocalidad = L.ID
Left Join Provincias P on P.ID = L.IDProvincia