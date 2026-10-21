DROP DATABASE IF EXISTS eficaz_fumigaciones;
CREATE DATABASE eficaz_fumigaciones;
USE eficaz_fumigaciones;

create table Clientes (
idCliente int auto_increment primary key,
tipoDocuemnto VARCHAR (20) not null,
numDocumento varchar (20) not null unique,
nombreCliente varchar (100) not null,
celularCliente varchar(20) not null,
correoCliente varchar(100) not null,
estadoCliente varchar(20) not null default 'Activo'
);

create table CitaFumigacion (
    idCita int auto_increment primary key,
    fechaHora datetime not null,
    estadoCita varchar(20) not null default 'Pendiente',
    tipoSolicitud varchar(50) not null
);


create table VisitaCotizacion (
    idVisitaCotizacion int auto_increment primary key,
    valorServicio decimal(10,2) not null default 0.00,
    tipoPropiedad varchar(50) not null,
    areaM2 decimal(10,2) not null check (areaM2 > 0),
    direccionPropiedad varchar(150) not null,
    idCita int not null,
    foreign key (idCita) references CitaFumigacion(idCita) on delete cascade 
);


create table InsumoQuimico (
    idInsumoQuimico int auto_increment primary key,
    nombreInsumo varchar(100) not null unique,
    unidadMedida varchar(20) not null,
    stockActual decimal(10,2) not null check (stockActual >= 0),
    stockMinimo varchar(50) not null,
    precioListaActual decimal(10,2) not null check (precioListaActual > 0),
    estadoInsumo varchar(20) not null default 'Disponible'
);


create table Plaga (
    idPlaga int auto_increment primary key,
    nombrePlaga varchar(100) not null unique,
    tarifaPorM2 decimal(10,2) not null check (tarifaPorM2 > 0),
    dosisEstandarPorM2 decimal(10,2) not null check (dosisEstandarPorM2 > 0),
    idInsumoQuimico int not null,
    foreign key (idInsumoQuimico) references InsumoQuimico(idInsumoQuimico)
);


create table ServicioDirecto (
    idServicio int auto_increment primary key,
    costoTotal decimal(10,2) not null check (costoTotal >= 0),
    dosisInsumo decimal(10,2) not null check (dosisInsumo >= 0),
    estadoServicio boolean not null default true,
    fechaTransaccion datetime not null default current_timestamp,
    usuarioResponsable varchar(100) not null,
    detalleOperacion varchar(255),
    idCita int not null,
    idCliente int not null,
    idPlaga int not null,
    foreign key (idCita) references CitaFumigacion(idCita),
    foreign key (idCliente) references Clientes(idCliente),
    foreign key (idPlaga) references Plaga(idPlaga)
);


create table CertificadoFumigacion (
    idCertificado int auto_increment primary key,
    fechaEmision date not null,
    fechaVencimiento date not null,
    tokenEnlace varchar(30) not null unique,
    estadoVigencia varchar(20) not null default 'Vigente',
    idServicio int not null,
    idCliente int not null,
    foreign key (idServicio) references ServicioDirecto(idServicio),
    foreign key (idCliente) references Clientes(idCliente)
);


create table AjusteInventario (
    idAjuste int auto_increment primary key,
    fechaAjuste date not null,
    tipoAjuste varchar(50) not null,
    cantidad decimal(10,2) not null,
    justificacion varchar(255) not null,
    fechaTransaccionAjuste datetime not null default current_timestamp,
    usuarioResponsableAjuste varchar(100) not null,
    detalleAjuste varchar(255),
    idInsumoQuimico int not null,
    idServicio int null,
    foreign key (idInsumoQuimico) references InsumoQuimico(idInsumoQuimico),
    foreign key (idServicio) references ServicioDirecto(idServicio)
);


create table Proveedor (
    idProveedor int auto_increment primary key,
    nit varchar(20) not null unique,
    telefonoProveedor varchar(20) not null,
    correoProveedor varchar(100)not null,
    ciudadProveedor varchar(50) not null,
    estadoProveedor varchar(20) not null default 'Activo'
);


create table OrdenCompra (
    idCompra int auto_increment primary key,
    fechaCompra date not null,
    valorTotal decimal(10,2) not null check (valorTotal >= 0),
    estadoCompra varchar(20) not null default 'Pendiente',
    fechaTransaccionCompra datetime not null default current_timestamp, 
    usuarioResponsableCompra varchar(100) not null,
    detalleCompra varchar(255),
    idProveedor int not null,
    foreign key (idProveedor) references Proveedor(idProveedor)
);


create table DetalleOrdenCompra (
    idDetalle int auto_increment primary key,
    idCompra int not null,
    idInsumoQuimico int not null,
    foreign key (idCompra) references OrdenCompra(idCompra) on delete cascade,
    foreign key (idInsumoQuimico) references InsumoQuimico(idInsumoQuimico)
);



insert into Clientes (tipoDocuemnto, numDocumento, nombreCliente, celularCliente, correoCliente, estadoCliente) values
('CC', '1018400111', 'Carlos Mendoza', '3101234567', 'carlos.mendoza@gmail.com', 'Activo'),
('NIT', '900123456-1', 'Restaurante El Sabor', '3159876543', 'contacto@elsabor.com', 'Activo'),
('CC', '52890123', 'Martha Gómez', '3004567890', 'martha.gomez@gmail.com', 'Activo'),
('CC', '1020789456', 'Andrés Rocha', '3123456789', 'andres.rocha@gmail.com', 'Activo'),
('NIT', '800555444-2', 'Panadería Central', '3186549870', 'administracion@pancentral.com', 'Activo'),
('CC', '1032456789', 'Luisa Fernanda Paez', '3019876543', 'luisa.paez@gmail.com', 'Activo'),
('NIT', '901234888-3', 'Hotel Plaza Real', '3174561230', 'gerencia@hotelplazareal.com', 'Activo'),
('CC', '80123456', 'Jorge Enrique Bustos', '3112223344', 'jorge.bustos@gmail.com', 'Activo'),
('CC', '1015678901', 'Diana Marcela Torres', '3145556677', 'diana.torres@gmail.com', 'Activo'),
('NIT', '830111222-5', 'Colegio San José', '3208889900', 'rectoria@sanjose.edu.co', 'Activo');

-- Inserción de los 40 Clientes restantes (del 11 al 50)
insert into Clientes (tipoDocuemnto, numDocumento, nombreCliente, celularCliente, correoCliente, estadoCliente)values
('CC', '1000000011', 'Cliente 11', '3000000011', 'cliente11@gmail.com', 'Activo'),
('CC', '1000000012', 'Cliente 12', '3000000012', 'cliente12@gmail.com', 'Activo'),
('CC', '1000000013', 'Cliente 13', '3000000013', 'cliente13@gmail.com', 'Activo'),
('CC', '1000000014', 'Cliente 14', '3000000014', 'cliente14@gmail.com', 'Activo'),
('CC', '1000000015', 'Cliente 15', '3000000015', 'cliente15@gmail.com', 'Activo'),
('NIT', '9000000016', 'Empresa 16', '3000000016', 'empresa16@gmail.com', 'Activo'),
('NIT', '9000000017', 'Empresa 17', '3000000017', 'empresa17@gmail.com', 'Activo'),
('NIT', '9000000018', 'Empresa 18', '3000000018', 'empresa18@gmail.com', 'Activo'),
('NIT', '9000000019', 'Empresa 19', '3000000019', 'empresa19@gmail.com', 'Activo'),
('NIT', '9000000020', 'Empresa 20', '3000000020', 'empresa20@gmail.com', 'Activo'),
('CC', '1000000021', 'Cliente 21', '3000000021', 'cliente21@gmail.com', 'Activo'),
('CC', '1000000022', 'Cliente 22', '3000000022', 'cliente22@gmail.com', 'Activo'),
('CC', '1000000023', 'Cliente 23', '3000000023', 'cliente23@gmail.com', 'Activo'),
('CC', '1000000024', 'Cliente 24', '3000000024', 'cliente24@gmail.com', 'Activo'),
('CC', '1000000025', 'Cliente 25', '3000000025', 'cliente25@gmail.com', 'Activo'),
('NIT', '9000000026', 'Empresa 26', '3000000026', 'empresa26@gmail.com', 'Activo'),
('NIT', '9000000027', 'Empresa 27', '3000000027', 'empresa27@gmail.com', 'Activo'),
('NIT', '9000000028', 'Empresa 28', '3000000028', 'empresa28@gmail.com', 'Activo'),
('NIT', '9000000029', 'Empresa 29', '3000000029', 'empresa29@gmail.com', 'Activo'),
('NIT', '9000000030', 'Empresa 30', '3000000030', 'empresa30@gmail.com', 'Activo'),
('CC', '1000000031', 'Cliente 31', '3000000031', 'cliente31@gmail.com', 'Activo'),
('CC', '1000000032', 'Cliente 32', '3000000032', 'cliente32@gmail.com', 'Activo'),
('CC', '1000000033', 'Cliente 33', '3000000033', 'cliente33@gmail.com', 'Activo'),
('CC', '1000000034', 'Cliente 34', '3000000034', 'cliente34@gmail.com', 'Activo'),
('CC', '1000000035', 'Cliente 35', '3000000035', 'cliente35@gmail.com', 'Activo'),
('NIT', '9000000036', 'Empresa 36', '3000000036', 'empresa36@gmail.com', 'Activo'),
('NIT', '9000000037', 'Empresa 37', '3000000037', 'empresa37@gmail.com', 'Activo'),
('NIT', '9000000038', 'Empresa 38', '3000000038', 'empresa38@gmail.com', 'Activo'),
('NIT', '9000000039', 'Empresa 39', '3000000039', 'empresa39@gmail.com', 'Activo'),
('NIT', '9000000040', 'Empresa 40', '3000000040', 'empresa40@gmail.com', 'Activo'),
('CC', '1000000041', 'Cliente 41', '3000000041', 'cliente41@gmail.com', 'Activo'),
('CC', '1000000042', 'Cliente 42', '3000000042', 'cliente42@gmail.com', 'Activo'),
('CC', '1000000043', 'Cliente 43', '3000000043', 'cliente43@gmail.com', 'Activo'),
('CC', '1000000044', 'Cliente 44', '3000000044', 'cliente44@gmail.com', 'Activo'),
('CC', '1000000045', 'Cliente 45', '3000000045', 'cliente45@gmail.com', 'Activo'),
('NIT', '9000000046', 'Empresa 46', '3000000046', 'empresa46@gmail.com', 'Activo'),
('NIT', '9000000047', 'Empresa 47', '3000000047', 'empresa47@gmail.com', 'Activo'),
('NIT', '9000000048', 'Empresa 48', '3000000048', 'empresa48@gmail.com', 'Activo'),
('NIT', '9000000049', 'Empresa 49', '3000000049', 'empresa49@gmail.com', 'Activo'),
('NIT', '9000000050', 'Empresa 50', '3000000050', 'empresa50@gmail.com', 'Activo');



insert into CitaFumigacion (fechaHora, estadoCita, tipoSolicitud) values
('2026-10-01 08:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-01 10:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-01 14:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-02 08:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-02 11:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-02 15:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-03 08:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-03 10:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-03 14:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-04 09:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-04 11:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-04 15:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-05 08:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-05 10:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-05 14:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-06 08:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-06 11:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-06 15:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-07 08:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-07 10:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-07 14:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-08 08:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-08 11:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-08 15:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-09 08:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-09 10:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-09 14:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-10 09:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-10 11:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-10 15:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-11 08:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-11 10:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-11 14:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-12 08:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-12 11:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-12 15:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-13 08:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-13 10:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-13 14:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-14 09:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-14 11:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-14 15:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-15 08:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-15 10:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-15 14:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-16 08:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-16 11:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-16 15:00:00', 'Realizado', 'Servicio Directo'),
('2026-10-17 08:00:00', 'Realizado', 'Servicio Directo'), ('2026-10-17 10:00:00', 'Realizado', 'Servicio Directo');

-- Tabla 3: Insumos Químicos Generales (5 Insumos Principales)
insert into InsumoQuimico (nombreInsumo, unidadMedida, stockActual, stockMinimo, precioListaActual, estadoInsumo) values
('Deltametrina 2.5%', 'ml', 15000.00, '1000 ml', 45.00, 'Disponible'),
('Gel Cucarachicida Alfa', 'g', 5000.00, '200 g', 120.00, 'Disponible'),
('Raticida Bloque Parafina', 'g', 10000.00, '500 g', 35.00, 'Disponible'),
('Termiticida Líquido B', 'ml', 8000.00, '1000 ml', 90.00, 'Disponible'),
('Insecticida Rastrero C', 'ml', 12000.00, '800 ml', 40.00, 'Disponible');


insert into Plaga (nombrePlaga, tarifaPorM2, dosisEstandarPorM2, idInsumoQuimico) values
('Cucaracha Germánica', 2000.00, 5.00, 1),
('Roedor Doméstico', 2500.00, 10.00, 3),
('Termita de Madera', 3500.00, 8.00, 4),
('Insectos Rastreros Varios', 1800.00, 4.00, 5),
('Hormiga de Jardín/Estructura', 2200.00, 3.50, 2);


insert into ServicioDirecto (costoTotal, dosisInsumo, estadoServicio, fechaTransaccion, usuarioResponsable, detalleOperacion, idCita, idCliente, idPlaga) values
(200000.00, 500.00, TRUE, '2026-10-01 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 1, 1, 1),
(200000.00, 500.00, TRUE, '2026-10-01 11:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 2, 2, 1),
(200000.00, 500.00, TRUE, '2026-10-01 15:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 3, 3, 1),
(200000.00, 500.00, TRUE, '2026-10-02 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 4, 4, 1),
(200000.00, 500.00, TRUE, '2026-10-02 12:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 5, 5, 1),
(200000.00, 500.00, TRUE, '2026-10-02 16:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 6, 6, 1),
(200000.00, 500.00, TRUE, '2026-10-03 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 7, 7, 1),
(200000.00, 500.00, TRUE, '2026-10-03 11:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 8, 8, 1),
(200000.00, 500.00, TRUE, '2026-10-03 15:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 9, 9, 1),
(200000.00, 500.00, TRUE, '2026-10-04 10:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 10, 10, 1),
(200000.00, 500.00, TRUE, '2026-10-04 12:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 11, 11, 1),
(200000.00, 500.00, TRUE, '2026-10-04 16:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 12, 12, 1),
(200000.00, 500.00, TRUE, '2026-10-05 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 13, 13, 1),
(200000.00, 500.00, TRUE, '2026-10-05 11:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 14, 14, 1),
(200000.00, 500.00, TRUE, '2026-10-05 15:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 15, 15, 1),
(200000.00, 500.00, TRUE, '2026-10-06 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 16, 16, 1),
(200000.00, 500.00, TRUE, '2026-10-06 12:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 17, 17, 1),
(200000.00, 500.00, TRUE, '2026-10-06 16:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 18, 18, 1),
(200000.00, 500.00, TRUE, '2026-10-07 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 19, 19, 1),
(200000.00, 500.00, TRUE, '2026-10-07 11:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 20, 20, 1),
(200000.00, 500.00, TRUE, '2026-10-07 15:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 21, 21, 1),
(200000.00, 500.00, TRUE, '2026-10-08 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 22, 22, 1),
(200000.00, 500.00, TRUE, '2026-10-08 12:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 23, 23, 1),
(200000.00, 500.00, TRUE, '2026-10-08 16:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 24, 24, 1),
(200000.00, 500.00, TRUE, '2026-10-09 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 25, 25, 1),
(200000.00, 500.00, TRUE, '2026-10-09 11:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 26, 26, 1),
(200000.00, 500.00, TRUE, '2026-10-09 15:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 27, 27, 1),
(200000.00, 500.00, TRUE, '2026-10-10 10:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 28, 28, 1),
(200000.00, 500.00, TRUE, '2026-10-10 12:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 29, 29, 1),
(200000.00, 500.00, TRUE, '2026-10-10 16:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 30, 30, 1),
(200000.00, 500.00, TRUE, '2026-10-11 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 31, 31, 1),
(200000.00, 500.00, TRUE, '2026-10-11 11:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 32, 32, 1),
(200000.00, 500.00, TRUE, '2026-10-11 15:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 33, 33, 1),
(200000.00, 500.00, TRUE, '2026-10-12 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 34, 34, 1),
(200000.00, 500.00, TRUE, '2026-10-12 12:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 35, 35, 1),
(200000.00, 500.00, TRUE, '2026-10-12 16:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 36, 36, 1),
(200000.00, 500.00, TRUE, '2026-10-13 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 37, 37, 1),
(200000.00, 500.00, TRUE, '2026-10-13 11:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 38, 38, 1),
(200000.00, 500.00, TRUE, '2026-10-13 15:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 39, 39, 1),
(200000.00, 500.00, TRUE, '2026-10-14 10:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 40, 40, 1),
(200000.00, 500.00, TRUE, '2026-10-14 12:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 41, 41, 1),
(200000.00, 500.00, TRUE, '2026-10-14 16:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 42, 42, 1),
(200000.00, 500.00, TRUE, '2026-10-15 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 43, 43, 1),
(200000.00, 500.00, TRUE, '2026-10-15 11:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 44, 44, 1),
(200000.00, 500.00, TRUE, '2026-10-15 15:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 45, 45, 1),
(200000.00, 500.00, TRUE, '2026-10-16 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 46, 46, 1),
(200000.00, 500.00, TRUE, '2026-10-16 12:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 47, 47, 1),
(200000.00, 500.00, TRUE, '2026-10-16 16:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 48, 48, 1),
(200000.00, 500.00, TRUE, '2026-10-17 09:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 49, 49, 1),
(200000.00, 500.00, TRUE, '2026-10-17 11:30:00', 'Camilo Forero', 'Servicio estándar en propiedad', 50, 50, 1);


insert into CertificadoFumigacion (fechaEmision, fechaVencimiento, tokenEnlace, estadoVigencia, idServicio, idCliente) values
('2026-10-01', '2027-04-01', 'TOKEN0000000000000000000000001', 'Vigente', 1, 1),
('2026-10-01', '2027-04-01', 'TOKEN0000000000000000000000002', 'Vigente', 2, 2),
('2026-10-01', '2027-04-01', 'TOKEN0000000000000000000000003', 'Vigente', 3, 3),
('2026-10-02', '2027-04-02', 'TOKEN0000000000000000000000004', 'Vigente', 4, 4),
('2026-10-02', '2027-04-02', 'TOKEN0000000000000000000000005', 'Vigente', 5, 5),
('2026-10-02', '2027-04-02', 'TOKEN0000000000000000000000006', 'Vigente', 6, 6),
('2026-10-03', '2027-04-03', 'TOKEN0000000000000000000000007', 'Vigente', 7, 7),
('2026-10-03', '2027-04-03', 'TOKEN0000000000000000000000008', 'Vigente', 8, 8),
('2026-10-03', '2027-04-03', 'TOKEN0000000000000000000000009', 'Vigente', 9, 9),
('2026-10-04', '2027-04-04', 'TOKEN0000000000000000000000010', 'Vigente', 10, 10),
('2026-10-04', '2027-04-04', 'TOKEN0000000000000000000000011', 'Vigente', 11, 11),
('2026-10-04', '2027-04-04', 'TOKEN0000000000000000000000012', 'Vigente', 12, 12),
('2026-10-05', '2027-04-05', 'TOKEN0000000000000000000000013', 'Vigente', 13, 13),
('2026-10-05', '2027-04-05', 'TOKEN0000000000000000000000014', 'Vigente', 14, 14),
('2026-10-05', '2027-04-05', 'TOKEN0000000000000000000000015', 'Vigente', 15, 15),
('2026-10-06', '2027-04-06', 'TOKEN0000000000000000000000016', 'Vigente', 16, 16),
('2026-10-06', '2027-04-06', 'TOKEN0000000000000000000000017', 'Vigente', 17, 17),
('2026-10-06', '2027-04-06', 'TOKEN0000000000000000000000018', 'Vigente', 18, 18),
('2026-10-07', '2027-04-07', 'TOKEN0000000000000000000000019', 'Vigente', 19, 19),
('2026-10-07', '2027-04-07', 'TOKEN0000000000000000000000020', 'Vigente', 20, 20),
('2026-10-07', '2027-04-07', 'TOKEN0000000000000000000000021', 'Vigente', 21, 21),
('2026-10-08', '2027-04-08', 'TOKEN0000000000000000000000022', 'Vigente', 22, 22),
('2026-10-08', '2027-04-08', 'TOKEN0000000000000000000000023', 'Vigente', 23, 23),
('2026-10-08', '2027-04-08', 'TOKEN0000000000000000000000024', 'Vigente', 24, 24),
('2026-10-09', '2027-04-09', 'TOKEN0000000000000000000000025', 'Vigente', 25, 25),
('2026-10-09', '2027-04-09', 'TOKEN0000000000000000000000026', 'Vigente', 26, 26),
('2026-10-09', '2027-04-09', 'TOKEN0000000000000000000000027', 'Vigente', 27, 27),
('2026-10-10', '2027-04-10', 'TOKEN0000000000000000000000028', 'Vigente', 28, 28),
('2026-10-10', '2027-04-10', 'TOKEN0000000000000000000000029', 'Vigente', 29, 29),
('2026-10-10', '2027-04-10', 'TOKEN0000000000000000000000030', 'Vigente', 30, 30),
('2026-10-11', '2027-04-11', 'TOKEN0000000000000000000000031', 'Vigente', 31, 31),
('2026-10-11', '2027-04-11', 'TOKEN0000000000000000000000032', 'Vigente', 32, 32),
('2026-10-11', '2027-04-11', 'TOKEN0000000000000000000000033', 'Vigente', 33, 33),
('2026-10-12', '2027-04-12', 'TOKEN0000000000000000000000034', 'Vigente', 34, 34),
('2026-10-12', '2027-04-12', 'TOKEN0000000000000000000000035', 'Vigente', 35, 35),
('2026-10-12', '2027-04-12', 'TOKEN0000000000000000000000036', 'Vigente', 36, 36),
('2026-10-13', '2027-04-13', 'TOKEN0000000000000000000000037', 'Vigente', 37, 37),
('2026-10-13', '2027-04-13', 'TOKEN0000000000000000000000038', 'Vigente', 38, 38),
('2026-10-13', '2027-04-13', 'TOKEN0000000000000000000000039', 'Vigente', 39, 39),
('2026-10-14', '2027-04-14', 'TOKEN0000000000000000000000040', 'Vigente', 40, 40),
('2026-10-14', '2027-04-14', 'TOKEN0000000000000000000000041', 'Vigente', 41, 41),
('2026-10-14', '2027-04-14', 'TOKEN0000000000000000000000042', 'Vigente', 42, 42),
('2026-10-15', '2027-04-15', 'TOKEN0000000000000000000000043', 'Vigente', 43, 43),
('2026-10-15', '2027-04-15', 'TOKEN0000000000000000000000044', 'Vigente', 44, 44),
('2026-10-15', '2027-04-15', 'TOKEN0000000000000000000000045', 'Vigente', 45, 45),
('2026-10-16', '2027-04-16', 'TOKEN0000000000000000000000046', 'Vigente', 46, 46),
('2026-10-16', '2027-04-16', 'TOKEN0000000000000000000000047', 'Vigente', 47, 47),
('2026-10-16', '2027-04-16', 'TOKEN0000000000000000000000048', 'Vigente', 48, 48),
('2026-10-17', '2027-04-17', 'TOKEN0000000000000000000000049', 'Vigente', 49, 49),
('2026-10-17', '2027-04-17', 'TOKEN0000000000000000000000050', 'Vigente', 50, 50);


USE eficaz_fumigaciones;


-- 1. TABLA: Clientes (consulta básica y específicas) --

select * from Clientes;


select idCliente, numDocumento, nombreCliente, celularCliente, correoCliente 
from Clientes 
where tipoDocuemnto = 'CC' and estadoCliente = 'Activo';


select tipoDocuemnto, count(*) as TotalClientes 
from Clientes 
group by tipoDocuemnto;


select * from Clientes 
where numDocumento = '1018400111';


-- 2. TABLA: CitaFumigacion (consulta básica y específicas)

select * from CitaFumigacion;

select idCita, fechaHora, tipoSolicitud 
from CitaFumigacion 
where estadoCita = 'Realizado';

select tipoSolicitud, count(*) as CantidadCitas 
from CitaFumigacion 
group by tipoSolicitud;

select * from CitaFumigacion 
order by fechaHora desc;


-- 3. TABLA: VisitaCotizacion (consulta básica y específicas)

select * from VisitaCotizacion;


select v.idVisitaCotizacion, c.fechaHora, v.tipoPropiedad, v.areaM2, v.direccionPropiedad
from VisitaCotizacion v
inner join CitaFumigacion c on v.idCita = c.idCita;


select tipoPropiedad, avg(areaM2) as PromedioAreaM2 
from VisitaCotizacion 
group by tipoPropiedad;


-- 4. TABLA: InsumoQuimico (consulta básica y específicas)

select * from InsumoQuimico;

select idInsumoQuimico, nombreInsumo, stockActual, stockMinimo 
from InsumoQuimico 
where stockActual <= 1000.00;

select nombreInsumo, stockActual, precioListaActual, (stockActual * precioListaActual) as ValorTotalEnStock
from InsumoQuimico;


-- 5. TABLA: Plaga (consulta básica y específicas)

select * from Plaga;

select p.nombrePlaga, p.tarifaPorM2, i.nombreInsumo as QuimicoUtilizado
from Plaga p
inner join InsumoQuimico i on p.idInsumoQuimico = i.idInsumoQuimico;

select nombrePlaga, tarifaPorM2 
from Plaga 
where tarifaPorM2 > 2000.00;


-- 6. TABLA: ServicioDirecto (consulta básica y específicas) --

select * from ServicioDirecto;

select s.idServicio, c.nombreCliente, p.nombrePlaga, s.costoTotal, s.dosisInsumo, s.fechaTransaccion
from ServicioDirecto s
inner join Clientes c on s.idCliente = c.idCliente
inner join Plaga p on s.idPlaga = p.idPlaga;

select p.nombrePlaga, count(s.idServicio) AS ServiciosRealizados, sum(s.costoTotal) as TotalIngresos, avg(s.costoTotal) as CobroPromedio
from ServicioDirecto s
inner join Plaga p on s.idPlaga = p.idPlaga
group by p.nombrePlaga;

select idServicio, costoTotal, fechaTransaccion 
from ServicioDirecto 
where usuarioResponsable = 'Camilo Forero';


-- 7. TABLA: CertificadoFumigacion (consulta báscia y específicas)--

select * from CertificadoFumigacion;

select cert.idCertificado, cli.nombreCliente, cert.fechaEmision, cert.fechaVencimiento, cert.tokenEnlace
from CertificadoFumigacion cert
inner join Clientes cli on cert.idCliente = cli.idCliente
where cert.estadoVigencia = 'Vigente';


-- 8. TABLA: AjusteInventario(consulta básica y específicas)--

select * from AjusteInventario;

select a.idAjuste, i.nombreInsumo, a.tipoAjuste, a.cantidad, a.justificacion
from AjusteInventario a
inner join InsumoQuimico i on a.idInsumoQuimico = i.idInsumoQuimico
where a.idServicio is null;


-- 9. TABLA: Proveedor (consulta básica y específicas)--

select * from Proveedor;

select nit, correoProveedor, telefonoProveedor 
from Proveedor 
where ciudadProveedor = 'Bogotá' and estadoProveedor = 'Activo';


-- 10. TABLA: OrdenCompra(consulta báscia y específicas)--

select * from OrdenCompra;

select prv.nit, prv.correoProveedor, count(com.idCompra) as TotalOrdenes, sum(com.valorTotal) as InversionTotal
from OrdenCompra com
inner join Proveedor prv on com.idProveedor = prv.idProveedor
group by  prv.nit, prv.correoProveedor;

-- 11. TABLA: DetalleOrdenCompra (consulta básica y específicas)--

select * from DetalleOrdenCompra;

select d.idDetalle, o.idCompra, o.fechaCompra, p.correoProveedor, i.nombreInsumo
from DetalleOrdenCompra d
inner join OrdenCompra o on d.idCompra = o.idCompra
inner join Proveedor p on o.idProveedor = p.idProveedor
inner join InsumoQuimico i on d.idInsumoQuimico = i.idInsumoQuimico;

USE eficaz_fumigaciones;

--  5 MODIFICACIONES Y 1 ELIMINACIÓN

update Clientes 
set celularCliente = '3209998877' 
where idCliente = 1;

update Plaga 
set tarifaPorM2 = 2200.00 
where nombrePlaga = 'Cucaracha Germánica';

update InsumoQuimico 
set stockActual = stockActual + 5000.00 
where idInsumoQuimico = 1;

update CitaFumigacion 
set estadoCita = 'En Camino' 
where idCita = 5;

update OrdenCompra 
set valorTotal = 135000.00, detalleCompra = 'Pedido urgente con 10% de descuento aplicado' 
where idCompra = 3;

delete from DetalleOrdenCompra 
where idDetalle = 5;

USE eficaz_fumigaciones;

-- CONSULTAS MULTITABLA 

select 
    c.nombreCliente,
    cit.fechaHora as FechaCita,
    p.nombrePlaga,
    iq.nombreInsumo as QuimicoAplicado,
    s.costoTotal
from ServicioDirecto s
inner join Clientes c on s.idCliente = c.idCliente
inner join CitaFumigacion cit on s.idCita = cit.idCita
inner join Plaga p on s.idPlaga = p.idPlaga
inner join InsumoQuimico iq on p.idInsumoQuimico = iq.idInsumoQuimico;



select 
    prv.nit as Proveedor,
    oc.idCompra,
    oc.fechaCompra,
    iq.nombreInsumo as ProductoComprado,
    oc.valorTotal
from DetalleOrdenCompra doc
inner join OrdenCompra oc on doc.idCompra = oc.idCompra
inner join Proveedor prv on oc.idProveedor = prv.idProveedor
inner join InsumoQuimico iq on doc.idInsumoQuimico = iq.idInsumoQuimico;

select 
    cert.idCertificado,
    cli.nombreCliente,
    cli.celularCliente,
    s.costoTotal as MontoPagado,
    cert.fechaEmision,
    cert.fechaVencimiento,
    cert.tokenEnlace
from CertificadoFumigacion cert
inner join Clientes cli on cert.idCliente = cli.idCliente
inner join ServicioDirecto s on cert.idServicio = s.idServicio
where cert.estadoVigencia = 'Vigente';


-- SUBCONSULTAS 

select 
    c.idCliente,
    c.nombreCliente,
    s.costoTotal,
    s.fechaTransaccion
from ServicioDirecto s
inner join Clientes c on s.idCliente = c.idCliente
where s.costoTotal > (
    select avg(costoTotal) 
    from ServicioDirecto
);


select 
    idInsumoQuimico, 
    nombreInsumo, 
    stockActual, 
    estadoInsumo
from InsumoQuimico
where idInsumoQuimico not in (
    select distinct idInsumoQuimico 
    from DetalleOrdenCompra
);


select 
    idCliente, 
    nombreCliente, 
    correoCliente 
from Clientes c
where exists (
    select 1 
    from ServicioDirecto s 
    where s.idCliente = c.idCliente
);


select 
    nombrePlaga, 
    tarifaPorM2 
from Plaga
where tarifaPorM2 = (
    select max(tarifaPorM2) 
    from Plaga
);

USE eficaz_fumigaciones;

-- CREACIÓN DE VISTAS

create or replace view  Vista_ResumenServicios as
select 
    s.idServicio,
    c.nombreCliente,
    c.celularCliente,
    p.nombrePlaga,
    s.costoTotal,
    cert.tokenEnlace,
    cert.estadoVigencia
from ServicioDirecto s
inner join Clientes c on s.idCliente = c.idCliente
inner join Plaga p on s.idPlaga = p.idPlaga
left join CertificadoFumigacion cert on s.idServicio = cert.idServicio;

create or replace view Vista_AlertasInventario as
select 
    idInsumoQuimico,
    nombreInsumo,
    unidadMedida,
    stockActual,
    stockMinimo,
    precioListaActual,
    estadoInsumo
from InsumoQuimico
where stockActual <= 1000.00;

create or replace view  Vista_AgendaVisitas as
select 
    c.idCita,
    c.fechaHora,
    c.estadoCita,
    c.tipoSolicitud,
    v.tipoPropiedad,
    v.areaM2,
    v.direccionPropiedad
from CitaFumigacion c
inner join VisitaCotizacion v on c.idCita = v.idCita;


--  CREACIÓN DE PROCEDIMIENTOS ALMACENADOS 

delimiter //
create procedure sp_RegistrarCliente(
    in p_tipoDoc VARCHAR(20),
    in p_numDoc VARCHAR(20),
    in p_nombre VARCHAR(100),
    in p_celular VARCHAR(20),
    in p_correo VARCHAR(100)
)
begin
    
    if exists (select 1 from Clientes where numDocumento = p_numDoc) then
        signal sqlstate '45000' 
        set MESSAGE_TEXT = 'Error de Negocio: El número de documento ya se encuentra registrado.';
    else
        insert into Clientes (tipoDocumento, numDocumento, nombreCliente, celularCliente, correoCliente, estadoCliente)
        values (p_tipoDoc, p_numDoc, p_nombre, p_celular, p_correo, 'Activo');
    end if;
end //
delimiter ;


delimiter //
create procedure sp_ActualizarStockInsumo(
    in p_idInsumo INT,
    in p_cantidadAjuste DECIMAL(10,2)
)
begin
   
    update InsumoQuimico 
    set stockActual = stockActual + p_cantidadAjuste
   where idInsumoQuimico = p_idInsumo;
end //
delimiter ;

USE eficaz_fumigaciones;

-- TRIGGER 1: Descuento Automático de Stock e Insumos Químicos

delimiter //
create trigger trg_DescontarStockServicio
after insert on ServicioDirecto
for each row
begin
   
    update InsumoQuimico i
    inner join Plaga p on i.idInsumoQuimico = p.idInsumoQuimico
    SET i.stockActual = i.stockActual - new.dosisInsumo
    where p.idPlaga = new.idPlaga;
    
   
    insert into AjusteInventario (
        fechaAjuste, 
        tipoAjuste, 
        cantidad, 
        justificacion, 
        usuarioResponsableAjuste, 
        idInsumoQuimico, 
        idServicio
    )
    select 
        current date(), 
        'Consumo Servicio', 
        new.dosisInsumo, 
        'Descuento automático disparado por ejecución de servicio', 
        new.usuarioResponsable, 
        p.idInsumoQuimico, 
        new.idServicio
    from Plaga p 
    where p.idPlaga = new.idPlaga;
end //
delimiter ;


-- TRIGGER 2: Auditoría Automática de Cambios en Datos de Clientes

delimiter //
create trigger trg_AuditoriaActualizacionCliente
after update on Clientes
for each row
begin
    
    if old.celularCliente <> new.celularCliente or old.correoCliente <> new.correoCliente then
        insert into AjusteInventario (
            fechaAjuste, 
            tipoAjuste, 
            cantidad, 
            justificacion, 
            usuarioResponsableAjuste, 
            idInsumoQuimico, 
            idServicio
        )
        values (
            current_date(),
            'Auditoría Cliente',
            0.00,
            concat('Actualización de contacto cliente ID ', new.idCliente, ': ', old.celularCliente, ' -> ', new.celularCliente),
            'Sistema Automático',
            1,
            null
        );
    und if;
end //
delimiter ;
