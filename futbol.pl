cod:- use_module(conocimientoFutbol).
/*
Punto 1: Acciones del partido
Conocemos el nombre de cada jugador y las acciones que fueron pasando en el partido.
Las cuales son:
el dibu hizo una atajada en el minuto 122. También, en la tanda de penales atajó 2 de ellos.
messi metió 2 goles, uno en el minuto 108 de jugada y otro en el minuto 23 de penal. A su vez, también metió el primer penal de la tanda.
montiel metió el último penal de la tanda de penales.
Se pide modelar la base de conocimientos con las acciones y quienes las realizaron.
*/
jugador(elDibu).
jugador(messi).
jugador(montiel).
jugador(dePaul).

accion(elDibu, atajada(122)).
accion(elDibu, atajadaPenal(2)).
accion(messi, gol(108)).
accion(messi, gol(23)).
accion(messi, penal(1)).
accion(montiel,penal(5)).
accion(dePaul,tarjetaAmarilla(11)).

/*
Punto 2: Puntajes de las acciones
Queremos saber cuantos puntos suma cada acción. Los cuales son calculados de la siguiente forma:
Para las atajadas en tanda de penales, suman 15 * la cantidad que se hayan atajado
Para las otras atajadas, el puntaje se calcula como el minuto en el que ocurrió más 10
Para los goles, se calcula como el minuto en el que se metió más 20
Por último, para los penales que se metieron, en caso de que sea el primero suma  45 puntos mientras que si es el último suma 80 puntos
También, queremos saber cuantos puntos suma cada jugador. Es necesario que este predicado sea inversible.
*/

puntos(atajadaPenal(Minuto),Puntos):- Puntos is 15*Minuto.
puntos(atajada(Minuto),Puntos):- Puntos is Minuto+10.
puntos(gol(Minuto),Puntos):- Puntos is Minuto+20.
puntos(tarjetaAmarilla(Minuto),Puntos):- Puntos is 45-Minuto. 
puntos(penal(1),45).
puntos(penal(5),80).

puntosDeAcciones([A],Sumatoria,Total):-
    puntos(A,Sumatoria),
    Total is Sumatoria.

puntosDeAcciones([H|T],Sumatoria,Total):-
    puntos(H,Puntos),
    puntosDeAcciones(T,Sumatoria,Total),
    Total is Puntos + Sumatoria.


puntajeJugador(Jugador,Puntos):-
    jugador(Jugador),
    findall(Accion, accion(Jugador,Accion), Acciones),
    puntosDeAcciones(Acciones,_,Puntos).



