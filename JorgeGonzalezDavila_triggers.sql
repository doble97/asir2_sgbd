--3.Haz lo necesario para cada vez que hay un movimiento  se actualice el saldo de la cuenta de ese cliente con ese movimiento, ya se un ingreso o una retirada.
use ebanca;
drop trigger if exists ejercicio3;
delimiter //
create trigger ejercicio3 after insert on movimiento
for each row
begin
    declare total int;
    select cantidad into total from cuenta where cod_cuenta= new.cod_cuenta;
    update cuenta set cantidad = (total-new.cantidad)  where cod_cuenta = new.cod_cuenta;
end//
delimiter ;
INSERT INTO `ebanca`.`movimiento`
(dni,fechahora,cantidad,idmov,cod_cuenta)
VALUES
(1,'2011-02-01',4000,2,1);