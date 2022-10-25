--3.Haz lo necesario para cada vez que hay un movimiento  se actualice el saldo de la cuenta de ese cliente con ese movimiento, ya se un ingreso o una retirada.
use ebanca;
drop trigger if exists ejercicio3;
delimiter //
create trigger ejercicio3 after insert on movimiento
for each row
begin
    declare total int;
    select saldo into total from cuenta where cod_cuenta= new.cod_cuenta;
    update cuenta set saldo = (total-new.cantidad)  where cod_cuenta = new.cod_cuenta;
end//
delimiter ;
INSERT INTO `ebanca`.`movimiento`
(dni,fechahora,cantidad,idmov,cod_cuenta)
VALUES
(1,'2011-02-01',4000,2,1);
--4
use ebanca;
drop trigger if exists ejercicio4;
delimiter //
create trigger ejercicio4 after insert on movimiento 
for each row
begin
    declare saldo_actual int;
    select saldo into saldo_actual from cuenta where cod_cuenta = NEW.cod_cuenta;
    update cuenta set saldo = (saldo_actual+new.cantidad+100) where (cod_cuenta=NEW.cod_cuenta) and (timestampdiff(year, fecha_creacion, curdate())) and 
    (cod_cuenta in (select cod_cuenta from movimiento where fechahora between '2011-01-01' and '2011-03-31'));

end//
delimiter ;

--5
drop table if exists empleados;
create table empleados (
    id char(4) primary key, nom_emp varchar(15) not null, 
    salario decimal(6,2) default 1000, idJefe char(4),
    fechaAlta date not null,
    fechaBaja date,
    foreign key(idJefe) references empleados(id)
);
--6
LOAD DATA INFILE '/var/lib/mysql-files/empleados.csv'
into table empleados
fields terminated by ';'
enclosed by '"'
lines terminated by '\n'
ignore 1 rows;

-- 7
use ebanca;
drop trigger if exists ejercicio7;
delimiter //
create trigger ejercicio7 before update on empleados
for each row
begin
    declare comprobar decimal(6,2);
    select salario into comprobar from empleados where id=new.id;
    set comprobar = (120*comprobar)/100;
    if comprobar <new.salario then
        signal sqlstate '45000' set message_text = "No se puede aumentar el salario más de un 20%";
    end if;
end//
delimiter ;

-- ejercicio 8
use ebanca;
drop table if exists historial;
create table historial (id int primary key auto_increment, accion varchar(100), usuario varchar(100), fechahora_utc timestamp);
drop trigger if exists ejercicio8;
delimiter //
create trigger ejercicio8 after update on empleados
for each row
    begin
        declare usuarioModifica varchar(50);
        SELECT concat(USER,"@",host) into usuarioModifica FROM information_schema.processlist WHERE id = connection_id();
        insert into historial(accion, usuario, fechahora_utc) values(concat("Se ha modificado el usuario ", new.id), usuarioModifica, now()
        );
    end//
delimiter ;
-- SELECT concat(USER,"@",host) FROM information_schema.processlist WHERE id = connection_id();


-- ejercicio 9
use ebanca;
drop trigger if exists ejercicio9insert;
drop trigger if exists ejercicio9update;
delimiter //
create trigger ejercicio9insert before insert on empleados
for each row
    begin
        declare contador int;
        select count(idJefe) into contador from empleados where idJefe = new.idJefe;
        if contador >=3 then
            signal sqlstate '45000' set message_text = "No se pueden supervisar más de 3 empleados";
        end if;
    end//
delimiter ;
delimiter //
create trigger ejercicio9update before update on empleados
for each row
begin
    declare contador int;
    select count(idJefe) into contador from empleados where idJefe = new.idJefe;
    if contador >= 3 then 
        signal sqlstate '45000' set message_text = "No se pueden supervisar más de 3 empleados";
    end if;
end//
delimiter ;