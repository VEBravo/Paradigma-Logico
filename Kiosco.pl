atiende(dodain, lunes, horario(9,15)).
atiende(dodain, miercoles, horario(9,15)).
atiende(dodain, viernes, horario(9,15)).
atiende(lucas, martes, horario(10,20)).
atiende(juanC, sabados, horario(18,22)).
atiende(juanC, domingos, horario(18,22)).
atiende(juanFdS, jueves, horario(10, 20)).
atiende(juanFdS, viernes, horario(12, 20)).
atiende(leoC, lunes, horario(14, 18)).
atiende(leoC, miercoles, horario(14, 18)).
atiende(martu, miercoles, horario(23, 24)).

% Definir la relación para asociar cada persona con el rango horario que cumple, e incorporar las siguientes cláusulas:

%     vale atiende los mismos días y horarios que dodain y juanC.

atiende(vale, Dia, Horario):-
    atiende(dodain, Dia, Horario).
atiende(vale, Dia, Horario):-
    atiende(juanC, Dia, Horario).

%     nadie hace el mismo horario que leoC

% Por universo cerrado, como en la base de datos no hay nadie que atienda como leoC -> no existe nadie.

%     maiu está pensando si hace el horario de 0 a 8 los martes y miércoles

% Solo definimos hechos, no algo que este pensando.

% En caso de no ser necesario hacer nada, explique qué concepto teórico está relacionado y justifique su respuesta.

% --------------------------------------------------------------------------------------------------------------------------------

% Definir un predicado que permita relacionar un día y hora con una persona, en la que dicha persona atiende el kiosko. Algunos ejemplos:
%   si preguntamos quién atiende los lunes a las 14, son dodain, leoC y vale
%   si preguntamos quién atiende los sábados a las 18, son juanC y vale
%   si preguntamos si juanFdS atiende los jueves a las 11, nos debe decir que sí.
%   si preguntamos qué días a las 10 atiende vale, nos debe decir los lunes, miércoles y viernes.

% El predicado debe ser inversible para relacionar personas y días.

estaEnHorario(Persona, Dia, Horario):-
    atiende(Persona, Dia, horario(Hi, Hf)),
    Hi =< Horario,
    Hf >= Horario.

% Definir un predicado que permita saber si una persona en un día y horario determinado está atendiendo ella sola. 
% En este predicado debe utilizar not/1, y debe ser inversible para relacionar personas. Ejemplos:
%   si preguntamos quiénes están forever alone el martes a las 19, lucas es un individuo que satisface esa relación.
%   si preguntamos quiénes están forever alone el jueves a las 10, juanFdS es una respuesta posible.
%   si preguntamos si martu está forever alone el miércoles a las 22, nos debe decir que no (martu hace un turno diferente)
%   martu sí está forever alone el miércoles a las 23
%   el lunes a las 10 dodain no está forever alone, porque vale también está
    
estaSolo(Persona, Dia, Horario):-
    estaEnHorario(Persona, Dia, Horario),
    estaEnHorario(Persona2, Dia, Horario),
    not(Persona \= Persona2).

% Punto 4: posibilidades de atención (3 puntos / 1 punto)
% Dado un día, queremos relacionar qué personas podrían estar atendiendo el kiosko en algún momento de ese día. 
% Por ejemplo, si preguntamos por el miércoles, tiene que darnos esta combinatoria:
% nadie
% dodain solo
% dodain y leoC
% dodain, vale, martu y leoC
% vale y martu
% etc.
% Queremos saber todas las posibilidades de atención de ese día. La única restricción es que la persona atienda ese día 
% (no puede aparecer lucas, por ejemplo, porque no atiende el miércoles).
atiendenUnDia(Dia,Personas):-
    findall(Persona,distinct(atiende(Persona,Dia,_)),PersonasPosibles),
    sublistas(PersonasPosibles,Personas).

sublistas([],[]).
sublistas([_|Posibles],Personas):-
    sublistas(Posibles,Personas).
sublistas([Posible|Posibles],[Posible|Personas]):-
    sublistas(Posibles,Personas).

% Punto 5: ventas / suertudas (4 puntos)
% En el kiosko tenemos por el momento tres ventas posibles:
% golosinas, en cuyo caso registramos el valor en plata

%golosiona(Valor).

% cigarrillos, de los cuales registramos todas las marcas de cigarrillos que se vendieron (ej: Marlboro y Particulares)

%cigarrillos([Marca]).

% bebidas, en cuyo caso registramos si son alcohólicas y la cantidad

% bebida(alcohólica,Cant)
% bebida(noAlcohólica,Cant)

% Queremos agregar las siguientes cláusulas:
%fecha(Dia,Mes)
%venta(Persona,DiaSemana,fecha(Dia,Mes),Producto).

% dodain hizo las siguientes ventas el lunes 10 de agosto: golosinas por $ 1200, cigarrillos Jockey, golosinas por $ 50
venta(dodain,lunes,fecha(10,8),golosinas(1200)).
venta(dodain,lunes,fecha(10,8),golosinas(50)).
venta(dodain,lunes,fecha(10,8),cigarrillos([jockey])).

% dodain hizo las siguientes ventas el miércoles 12 de agosto: 8 bebidas alcohólicas, 1 bebida no-alcohólica, golosinas por $ 10
venta(dodain,miercoles,fecha(12,8),bebida(alcohólica,8)).
venta(dodain,miercoles,fecha(12,8),bebida(noAlcohólica,1)).
venta(dodain,miercoles,fecha(12,8),golosinas(50)).

% martu hizo las siguientes ventas el miercoles 12 de agosto: golosinas por $ 1000, cigarrillos Chesterfield, Colorado y Parisiennes.
% lucas hizo las siguientes ventas el martes 11 de agosto: golosinas por $ 600.
% lucas hizo las siguientes ventas el martes 18 de agosto: 2 bebidas no-alcohólicas y cigarrillos Derby.

% Queremos saber si una persona vendedora es suertuda, esto ocurre si para todos los días en los que vendió, la primera venta que hizo fue importante. Una venta es importante:
% en el caso de las golosinas, si supera los $ 100.
% en el caso de los cigarrillos, si tiene más de dos marcas.
% en el caso de las bebidas, si son alcohólicas o son más de 5.

% El predicado debe ser inversible: martu y dodain son personas suertudas.
ventaImportante(golosina(Precio)):-Precio>100.
ventaImportante(cigarrillos(Lista)):- length(Lista,Cant), Cant > 2.
ventaImportante(bebida(alcohólica,_)).
ventaImportante(bebida(_,Cant)):- Cant > 5.

vendedorSuertudo(Persona):-
    persona(Persona),
    forall(venta(Persona,Dia,_,_),)
   

