:- module(conocimiento, [jugador/1, tecnologia/1, civilizacion/1, partida/3]).

tecnologia(herreria).
tecnologia(forja).
tecnologia(fundicion).
tecnologia(emplumado).
tecnologia(laminas).

civilizacion(romanos).
civilizacion(incas).

jugador(ana).
jugador(beto).
jugador(carola).
jugador(dimitri).
jugador(elsa).

partida(ana,romanos,[herreria,forja,emplumado,laminas]).
partida(beto,incas,[herreria,forja,fundicion]).
partida(carola,romanos,[herreria]).
partida(dimitri,romanos,[herreria,fundicion]).