/*
CUANDO USAR LISTAS
- Cuando se quiere contar.
- Cuando se quiere sumar.


COSAS
- Los predicados solo devuelven true o false.
- REPL, la consola es la que se encarga de imprimir: read, evaluate, print, loop. El que imprime es el REPL y su interfaz de texto.

*/

paises(america,[argentina,brasil,peru,chile,uruguay]).
paises(europa,[italia,francia,espania,portugal,grecia,suiza,inglaterra]).


cantidadPaises(Continente,Cantidad):-
    paises(Continente,Paises),
    length(Paises, Cantidad).

/*FUNCIONES CON LISTAS   
    sumlist([3,4,5],12) -> true     y      sumlist(L,12) -> Error, no es inversible el parámetro que remite la lista
    length(X,3) -> X = [_,_,_]
    member(3,[3,4,5])   -> true     y      member(3,L) -> L=[3|_]
                                                          L=[_,3|_]
                                                          L=[_,_,3|_]
    append(L1,L2,L3)                Relaciona listas, es completamente inversible.
    conquisto(Cont,Color):- forall(pais(Cont,P),ocupa(P,Color,_))
        No lo puedo usar inversiblemente porque lo que me responde cuando le hago una consulta existencial no responde
        lo que estoy buscando que responda. Me dice si todos paises que ocupan el continente tienen cierto color.
    member(3,L),length(L,3) se queda colgado buscando más listas que cumplan, si cambio el orden solo me da las 3
    nth1(Posicion,Lista,Elemento).

CONSIDERAR 
    Solo se considera inversible cuando puedo consultar todos los casos.

CUANDO UNA X = algo decimos que UNIFICA CON ese algo
*/

% EJEMPLO

persona(valentin,bsas,fecha(5,8,2004)).
edad(fecha(_,_,Anio),Edad):- Edad is 2024 - Anio.

esMayor(P):-
    persona(_,Dia,Mes,Anio),
    edad(Dia,Mes,Anio,Edad),
    Edad =>18.



