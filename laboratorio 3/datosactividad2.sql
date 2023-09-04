use AppRecetas
go
Insert into UnidadesMedida(IDUnidadMedida, Nombre)
VALUES
(1, 'Gramos'),
(2,'CC'),
(3,'Cucharada'),
(4,'Unidad'),
(5,'Taza')
go


Insert into Platos(IDPlato,Nombre,Descripcion,TiempoPreparacion,Calorias,Dificultad)
VALUES
(1, 'Latte' , 'Cafe con leche', 4, 30, 0.5),
(2, 'Higado encebollado', 'Higado de vaca acariciadopor finas laminas de cebolla', 30,500,2.3)
go

Insert into Ingredientes (IDIngrediente,Nombre, Vegano, Vegetariano, Celiaco)
Values
(1, 'Cafe', 1,1,1)
GO

Insert into Ingredientes(IDIngrediente,Nombre,Celiaco)
Values
(2,'Leche',1)
GO

Insert into Ingredientes(IDIngrediente,Nombre,Celiaco)
Values
(3,'Higado',1)
GO
Insert into Ingredientes(IDIngrediente,Nombre,Vegano,Vegetariano,Celiaco)
Values (4, 'Cebolla', 1,1,1)


