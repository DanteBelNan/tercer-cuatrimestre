Create Database AppRecetas
Go
Use AppRecetas
go

Create Table Ingredientes(
    IDIngrediente int not null,
    Nombre varchar(100) not null,
    Vegano bit not null default(0),
    Vegetariano bit not null default(0),
    Celiaco bit not null default(0),
)
Go
Create Table Platos(
    IDPlato int not null,
    Nombre varchar(100),
    Descripcion varchar(500) null,
    TiempoPreparacion int null, --minutos
    Calorias int null,
    Dificultad decimal(2,1) null,
)

Go
Create Table Recetas(
    IDReceta int not null,
    IDPlato int not null,
    IDIngrediente int not null,
    Cantidad decimal(6, 2)   not null,
    IDUnidadMedida TINYINT not null,
)

go
Create table UnidadesMedida(
    IDUnidadMedida TINYINT not null,
    Nombre varchar(50),

    Primary Key(IDUnidadMedida),
)

go
Alter Table Ingredientes
Add CONSTRAINT PK_Ingredientes Primary Key (IDIngrediente)

go
Alter Table Platos
Add Constraint PK_Platos Primary Key (IDPlato)
go
Alter Table Platos
Add CONSTRAINT CHK_TiempoPreparacion Check (TiempoPreparacion >= 0)
go
Alter Table Platos
Add CONSTRAINT CHK_Calorias Check (Calorias >= 0)
go
Alter Table Platos
Add CONSTRAINT CHK_Dificultad Check (Dificultad >= 0 and Dificultad <= 5)

go
Alter Table Recetas
    ADD CONSTRAINT PK_Recetas PRIMARY KEY (IDPlato, IDIngrediente)

go
Alter Table Recetas
    Add CONSTRAINT FK_Recetas_Platos FOREIGN KEY (IDPlato) 
    REFERENCES Platos(IDPlato)

go
Alter Table Recetas
    Add CONSTRAINT FK_Recetas_Ingrediente FOREIGN KEY (IDIngrediente) 
    REFERENCES Ingredientes (IDIngrediente)

go
Alter Table Recetas
    ADD CONSTRAINT FK_Recetas_UnidadMedida FOREIGN Key (IDUnidadMedida) 
    REFERENCES UnidadesMedida(IDUnidadMedida)

go
Alter Table Recetas
    Add CONSTRAINT CHK_Cantidad Check (Cantidad > 0)



