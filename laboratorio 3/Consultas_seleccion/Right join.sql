Select C.Apellidos, C.Nombres, C.Direccion, L.Nombre as Localidad, P.Nombre as Provincia From Localidades L
Left Join Clientes C on C.IDLocalidad = L.ID
Right Join Provincias P on P.ID = L.IDProvincia
Where C.ID Is Null and L.ID is NULL