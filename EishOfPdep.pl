:- use_module(conocimiento).

% Saber si un jugador es experto en metales, que sucede cuando desarrolló las tecnologías de herrería, 
% forja y o bien desarrolló fundición o bien juega con los romanos.
% En los ejemplos, Ana y Beto son expertos en metales, pero Carola y Dimitri no.
desarrolloTecnologia(Jugador,Tecnologia):-
    partida(Jugador,_,Tecnologias),
    member(Tecnologia,Tecnologias).

expertoEnMetales(Jugador):-
    jugador(Jugador),
    desarrolloTecnologia(Jugador,herreria),
    desarrolloTecnologia(Jugador,forja),
    desarrolloTecnologia(Jugador,fundicion).

expertoEnMetales(Jugador):-
    jugador(Jugador),
    partida(Jugador,romanos,_),
    desarrolloTecnologia(Jugador,herreria),
    desarrolloTecnologia(Jugador,forja).

% Saber si una civilización es popular, que se cumple cuando la eligen varios jugadores (más de uno).
% En los ejemplos, los romanos es una civilización popular, pero los incas no.

esPopular(Civilizacion):-
    partida(Jugador1,Civilizacion,_),
    partida(Jugador2,Civilizacion,_),
    Jugador1 \= Jugador2.

% Saber si una tecnología tiene alcance global, que sucede cuando a nadie le falta desarrollarla.
% En los ejemplos, la herrería tiene alcance global, pues Ana, Beto, Carola y Dimitri la desarrollaron.

tieneAlcanceGlobal(Tecnologia):-
    desarrolloTecnologia(_,Tecnologia),
    forall(partida(Jugador,_,_),desarrolloTecnologia(Jugador,Tecnologia)).

% Saber cuándo una civilización es líder. Se cumple cuando esa civilización alcanzó todas las tecnologías 
% que alcanzaron las demás.
% En los ejemplos, los romanos es una civilización líder pues entre Ana y Dimitri, que juegan con romanos, ya tienen todas 
% las tecnologías que se alcanzaron.
alcanzoTecnologia(Civilizacion,Tecnologia):-
    partida(_,Civilizacion,Tecnologias),
    member(Tecnologia, Tecnologias).
    
esLider(Civilizacion):-
    civilizacion(Civilizacion),
    findall(Tecnologia, desarrolloTecnologia(_, Tecnologia), ListaTecnologias),
    forall(member(T,ListaTecnologias),alcanzoTecnologia(Civilizacion,T)).
