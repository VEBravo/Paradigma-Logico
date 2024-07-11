% Hearthstone es un juego de cartas entre dos jugadores. 
% Cada jugador tiene un nombre, un mazo de cartas, una cantidad de puntos de vida, una cantidad de puntos de maná, cartas en la mano y cartas de criatura en el campo. 
% Pierde el primer jugador en llegar a cero de vida.
% Todas las cartas del juego tienen nombre. 
% Las cartas de criatura, además, tienen danio (de un ataque de la criatura), vida y costo en maná. 
% Las cartas de hechizo, en cambio, tienen el efecto de curar o daniar en una cantidad de puntos de vida, y un correspondiente costo en maná.
% En cada turno, un jugador puede gastar su mana para usar hechizos o invocar criaturas que tiene en la mano al campo, y atacar con sus criaturas.
% El estado actual del juego se modela en base a hechos jugador/1, los cuales se cumplen para un functor jugador/6. 
% Los functores tienen el siguiente formato:
% jugadores
jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo).

% cartas
criatura(Nombre, PuntosDanio, PuntosVida, CostoMana).
hechizo(Nombre, FunctorEfecto, CostoMana).

% efectos
danio(CantidadDanio).
cura(CantidadCura).

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

danio(criatura(_,Danio,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).
mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

% Relacionar un jugador con una carta que tiene. La carta podría estar en su mano, en el campo o en el mazo.

tieneCarta(Jugador, Carta):-
    jugador(Jugador),
    cartaMazo(Jugador, Cartas),
    member(Carta, Cartas).

tieneCarta(Jugador, Carta):-
    jugador(Jugador),
    cartasMano(Jugador, Cartas),
    member(Carta, Cartas).

tieneCarta(Jugador, Carta):-
    jugador(Jugador),
    cartasCampo(Jugador, Cartas),
    member(Carta, Cartas).

% Saber si un jugador es un guerrero. Es guerrero cuando todas las cartas que tiene, ya sea en el mazo, la mano o el campo, son criaturas.

esCriatura(criatura(_,_,_,_)).

esGuerrero(Jugador):-
    jugador(Jugador),
    forall(tieneCarta(Jugador,Carta),esCriatura(Carta)).

% Relacionar un jugador consigo mismo después de empezar el turno. Al empezar el turno, la primera carta del mazo pasa a estar en la mano y el jugador gana un punto de maná.



