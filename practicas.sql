--- ejercicio 1
delimiter //
create procedure anioactual()
begin
	select year(now()) as anioactual;
end//
delimiter ;

--- ejercicio 2
delimiter //
create procedure anioactual(in cadena varchar(100))
begin
	select left(upper(cadena),3) as tresLetras;
end//
delimiter ;

--- ejercicio 3
delimiter //
create procedure concatmayus(in cadena1 varchar(100), in cadena2 varchar(100))
begin
	select upper(concat(cadena1, ' ', cadena2)) as palabras;
end//
delimiter ;

--- ejercicio 4, con parametro out devuelve un null al acceder desde afuera
delimiter //
create procedure sumauno(inout contador int )
begin
	set contador = contador+1;
end//
delimiter ;

--- ejercicio 5 Crea un procedimiento que devuelva el nombre de los ciclistas
--- que pertenezcan al mismo equipo que un corredor que se le pasa por parámetro.
--- Utiliza la base de datos Ciclistas.
delimiter //
create procedure CorredoresCompanero(in nombreCiclista varchar(100))
begin
	select nombre from ciclistas where nomeq = (select nomeq from ciclistas where nombre = nombreCiclista);
end//
delimiter ;

--- ejercicio 6 Crea un procedimiento que devuelva  el nombre de los ciclistas que
--- han ganado más del número de puertos que se le pasa por parámetro. Utiliza
--- la base de datos Ciclistas.
delimiter //
create procedure CorredoresGanadoresPuertos(in numero int)
begin
	select ciclistas.nombre, count(ciclistas.nombre ) as puertos from ciclistas join puertos on ciclistas.dorsal = puertos.dorsalganador group by ciclistas.nombre having puertos >numero order by puertos, ciclistas.nombre;
end//
delimiter ;

--- ejercicio 7 Crea un procedimiento que devuelva  el valor del atributo netapa
--- de aquellas etapas tales que todos los puertos que están en ellas tenga más
--- los metros que se le pasa por parámetro. Utiliza la base de datos Ciclistas.
delimiter //
create procedure EtapasPuertosAltura(in alturaPuerto int)
begin
	select etapas.numero from etapas where etapas.numero not in (select numetapa from puertos where altura<=alturaPuerto) and etapas.numero in (select numetapa from puertos where altura >alturaPuerto) order by etapas.numero;
end//
delimiter ;

--- ejercicio 8 Crear un procedimiento que devuelva el nombre y el director de
--- los equipos tales que todos sus ciclistas son mayores de una edad que se pasa
--- por parámetro. Utiliza la base de datos Ciclistas.
--- REVISAR CON PROFESOR
delimiter //
create procedure EdadEquipos(in edadCiclista int)
begin
    	select nombre, director from equipos where nombre not in (select nomeq from ciclistas where edad <edadCiclista) and nombre in (select nomeq from ciclistas where edad >=edadCiclista) order by nombre;
end//
delimiter ;

--- ejercicio 9 Crear un procedimiento que devuelva el valor del atributo netapa,
--- la ciudad de salida y la ciudad de llegada de las etapas de más de un determinado
--- número de kilómetros  y   un mínimo de puertos que se pasan por parámetros.
--- Utiliza la base de datos Ciclistas.
delimiter //
create procedure EtapaKilometrosPuertos(in km int, in numPuertos int)
begin
	select numero, salida, llegada from (select etapas.numero, count(etapas.numero) as num_etapas , etapas.salida , etapas.llegada from etapas join puertos on etapas.numero = puertos.numetapa where puertos.altura >km group by etapas.numero having num_etapas>=numPuertos) as sel1;
end//
delimiter ;

--- ejercicio 2.1 Crea una función que devuelva el valor de la hipotenusa de un
--- triángulo a partir de los valores de sus lados. Utiliza la base de datos Ventas.
delimiter //
create function hipotenusa(a int, b int)
returns double
deterministic
begin
	declare resultado double;
	set resultado = sqrt(pow(a,2)+pow(b,2));
	return resultado;
end//
delimiter ;

--- ejercicio 2.2 Crea una función que calcule el total de puntos en un partido de
--- baloncesto tomando como entrada el resultado en formato 'xxx-xxx'. Utiliza la
--- base de datos Ventas.
delimiter //
create function total(puntos varchar(10))
returns int
deterministic
begin  
	declare resultado int;
	set resultado = substring_index(puntos,"-", 1) + substring_index(puntos,"-", -1);
	return resultado;
end//
delimiter ;

--- ejercicio 2.3 Crea una función que calcule el número de años transcurridos entre
--- 2 fechas donde la primera es menor que la segunda (para probarlo calcula tu
--- edad introduciendo tu fecha de nacimiento y la fecha actual).
delimiter //
create function datesDiff(fecha1 varchar(20), fecha2 date)
returns int
deterministic
begin
	declare anios int;
	set anios = timestampdiff(year,fecha1,fecha2);
	return anios;
end//
delimiter ;


--- ejercicio 2.4 Crea una función  que devuelva  la edad media de los ciclistas que
--- han ganado alguna etapa. Utiliza la base de datos Ciclistas.
delimiter //
create function EdadMedia()
returns float
deterministic
begin
    declare anios float;
    select avg(distinct ciclistas.edad) into anios from ciclistas join puertos on ciclistas.dorsal = puertos.dorsalganador;
    return anios;
end//
delimiter ;


---- *******
---- *******
---- *******
---- *******
--- 3.1 Crea una función que reciba 2 números enteros y devuelva 1, si el primer
--- número es divisible por el otro y 0, en caso contrario. Utiliza la base de
--- datos Ventas.
delimiter //
create function divisible(a int, b int)
returns int
deterministic
begin
	declare resto int;
	set resto = MOD(a,b);
	if resto = 0 then
    	return 1;
	else
    	return 0;
	end if;
end//
delimiter ;

--- 3.2 Crea una función, usando las estructuras condicionales, que devuelva el
--- literal del día de la semana según un valor de entrada numérico, 1 para lunes,
--- 2 martes, etc. Utiliza la base de datos Ventas.
delimiter //
create function diasemana(dia int)
returns varchar(10)
deterministic
begin
	if dia=1 then
    	return "Lunes";
	elseif dia=2 then
    	return "Martes";
	elseif dia=3 then
    	return "Miercoles";
	elseif dia=4 then
    	return "Jueves";
	elseif dia=5 then
    	return "Viernes";
	elseif dia=6 then
    	return "Sábado";
	else
    	return "Domingo";
	end if;
end//
delimiter ;
---- alternativa switch case
delimiter //
create function diasemana(dia int)
returns varchar(10)
deterministic
begin
	case dia
    	when 1 then
        	return 'Lunes';
    	when 2 then
        	return 'Martes';
    	when 3 then
        	return 'Miercoles';
    	when 4 then
        	return 'Jueves';
    	when 5 then
        	return 'Viernes';
    	when 6 then
        	return 'Sábado';
    	else
        	return 'Domingo';
	end case;
end//
delimiter ;

--- 3.3 Crea una función que devuelva el mayor de tres números pasados como
--- parámetros, sin usar la función GREATEST. Utiliza la base de datos Ventas.
delimiter //
create function mayor(a int, b int, c int)
returns int
deterministic
begin
	if a=b and b=c then
    	return a;
	elseif a > b then
    	if a >c then
        	return a;
    	else
        	return c;
    	end if;
	elseif b >a then
    	if b>c then
        	return b;
    	else
        	return c;
    	end if;
	else
    	return c;
	end if;
end//
delimiter ;

--- 3.4 Crea una función que devuelva 1 si ganó el de casa, 2 el visitante
--- y 0 si empataron. El parámetro de entrada es el resultado con el formato
--- 'xxx-xxx'. Utiliza la base de datos Ventas.
delimiter //
create function ganador(puntos varchar(7))
returns int
deterministic
begin
	declare casa int;
	declare visitante int;
	set casa = substring_index(puntos,'-',1);
	set visitante = substring_index(puntos,'-',-1);
	if casa=visitante then
    	return 0;
	elseif casa>visitante then
    	return 1;
	else
    	return 2;
	end if;
end//
delimiter ;

--- 3.5 Crea una función que diga si una palabra, pasada como parámetro,
--- es palíndroma (por ejemplo: radar, reconocer, sometemos,  ...). Devuelve
--- 1 si es palíndroma y 0 en caso contrario.Utiliza la base de datos Ventas.
delimiter //
create function palindrome(palabra varchar(30))
returns int
deterministic
begin
	declare reverso varchar(30);
	set reverso = reverse(palabra);
	if palabra = reverso then
    	return 1;
	else
    	return 0;
	end if;
end//
delimiter ;

--- 3.6 Crea una función que devuelva el valor “viejo” si la media de edad de
--- los corredores de un equipo que se le pasa por parámetro es mayor que la
--- media total de todos los corredores. Devolverá “joven” si la media del equipo
--- es menor.
delimiter //
create function EdadEquipo(nombreEquipo varchar(20))
returns varchar(5)
deterministic
begin  
	declare mediaEquipo float;
	declare mediaTotal float;
	select avg(edad) into mediaEquipo from ciclistas where nomeq=nombreEquipo;
	select avg(edad) into mediaTotal from ciclistas;
	if mediaEquipo > mediaTotal then
    	return 'viejo';
	elseif mediaEquipo < mediaTotal then
    	return 'joven';
	else
    	return 'error';
	end if;
end//
delimiter ;

--- 4.1 Crea un procedimiento que muestre por pantalla los números del 1 al 10.
delimiter //
create procedure mostrarnumeros()
begin
	declare count int;
	declare numeros varchar(50);
	set count=1;
	set numeros = "->";
	bucle:LOOP
    	if count>10 then LEAVE bucle;
    	end if;
      set numeros = concat(numeros,' ', count);
      set count = count +1;
      select numeros;
   end LOOP bucle;
end//
delimiter ;

--- 4.2 Crea un procedimiento que reciba dos números y haga la cuenta atrás desde el mayor hasta el menor.
--- El orden de los números es aleatorio, hay que comprobar cual es el mayor y el menor.
delimiter //
create procedure cuenta_atras(in x int, in y int)
begin
   declare mayor, menor, contador int;
   select GREATEST(x,y) into mayor;
   select least(x,y) into menor;
   set contador = mayor;
   bucle: LOOP
      if contador<menor then leave bucle;
      end if;
      select contador as max;
      set contador = contador-1;
   end loop bucle;
end//
delimiter ;

--- 4.3
use ventasleon;
drop procedure if exists genera_fechas_en;
delimiter //
create procedure genera_fechas_en(in dias int)
begin
   declare contador int default 0;
   drop table if exists fechas_en;
   create table fechas_en(Id int primary key auto_increment,
      Fecha date, Nombre varchar(10), NumDia int);
   bucle: LOOP
      if contador =dias then LEAVE bucle;
      end if;
      insert into fechas_en(Fecha, Nombre, NumDia) values(date_add(curdate(), interval contador day), date_format(
         date_add(curdate(), interval contador day),"%W"),
         date_format( date_add(curdate(), interval contador day),'%j' ));
         set contador = contador +1;
   end loop bucle;
   select * from fechas_en;
end //
delimiter ;
call genera_fechas_en(5);

--- 5.1 Dado un número, saca una lista con todos los números inferiores a él que son divisibles por 8. Por ejemplo,
--- si el número pasado como parámetro es el 32, nos deberá devolver lo siguiente: 24|16|8|.
delimiter //
create function divisibles(numero int)
returns varchar(100)
deterministic
begin
   declare numeros varchar(100) default '';
   set numero = numero -1;
   bucle: loop
      if numero < 8 then leave bucle;
      end if;
      if MOD(numero,8) = 0 then
         set numeros = concat(numeros,numero, '|');
      end if;
      set numero = numero -1;
   end loop bucle;
   return numeros;
end//
delimiter ;

--- 5.2 ejercicio anterior controlando que la entrada sea mayor que 8
delimiter //
create function divisibles(numero int)
returns varchar(100)
deterministic
begin
   declare numeros varchar(100) default '';
   set numero = numero -1;
   if numero = 8 then 
      set numeros = concat(numeros,"No permitido el valor");
   else
      bucle: loop
         if numero < 8 then leave bucle;
         end if;
         if MOD(numero,8) = 0 then
            set numeros = concat(numeros,numero, '|');
         end if;
         set numero = numero -1;
      end loop bucle;
   end if;

   return numeros;
end//
delimiter ;