pareja(marsellus, mia).
pareja(pumkin, honeyBunny).
pareja(bernardo, bianca).
pareja(bernardo, charo).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).

trabajaPara(Empleador,bernardo):- 
	trabajaPara(marsellus,Empleador),
	Empleador \= jules.
	
trabajaPara(Empleador,george):- saleCon(bernardo,Empleador).

saleCon(Persona,OtraPersona):- pareja(Persona,OtraPersona). % No es recursiva.
saleCon(Persona,OtraPersona):- pareja(OtraPersona,Persona).

esFiel(Persona):- 
	saleCon(Persona,UnaPersona),
	not((saleCon(Persona,OtraPersona),UnaPersona\=OtraPersona)).
	
acataOrden(Empleador,Empleado):- trabajaPara(Empleador,Empleado). % Caso base
acataOrden(Empleador,Empleado):- 
	trabajaPara(Empleador,Intermedio),
	acataOrden(Intermedio,Empleado). % Caso recursivo

% SEGUNDA PARTE

personaje(pumkin,     ladron([estacionesDeServicio, licorerias])).
personaje(honeyBunny, ladron([licorerias, estacionesDeServicio])).
personaje(vincent,    mafioso(maton)).
personaje(jules,      mafioso(maton)).
personaje(marsellus,  mafioso(capo)).
personaje(winston,    mafioso(resuelveProblemas)).
personaje(mia,        actriz([foxForceFive])).
personaje(butch,      boxeador).
personaje(bernardo,   mafioso(cerebro)).
personaje(bianca,     actriz([elPadrino1])).
personaje(elVendedor, vender([humo, iphone])).
personaje(jimmie,     vender([auto])).

% encargo(Solicitante, Encargado, Tarea).Las tareas pueden ser cuidar(Protegido), 
% ayudar(Ayudado), buscar(Buscado, Lugar)
encargo(marsellus, vincent,   cuidar(mia)).
encargo(vincent,  elVendedor, cuidar(mia)).
encargo(marsellus, winston, ayudar(jules)).
encargo(marsellus, winston, ayudar(vincent)).
encargo(marsellus, vincent, buscar(butch, losAngeles)).
encargo(bernardo, vincent, buscar(jules, fuerteApache)).
encargo(bernardo, winston, buscar(jules, sanMartin)).
encargo(bernardo, winston, buscar(jules, lugano)).

amigo(vincent, jules).
amigo(jules, jimmie).
amigo(vincent, elVendedor).

esPeligroso(Personaje):- personaje(Personaje,mafioso(maton)).
esPeligroso(Personaje):- personaje(Personaje,ladron(Lugares)), member(licorerias,Lugares).
esPeligroso(Personaje):- trabajaPara(Empleador,Personaje),esPeligroso(Empleador).

tieneCerca(Alguien,Otro):- amigo(Alguien,Otro).
tieneCerca(Alguien,Otro):- amigo(Otro,Alguien).
tieneCerca(Alguien,Otro):- trabajaPara(Alguien,Otro).
tieneCerca(Alguien,Otro):- trabajaPara(Otro,Alguien).

sanCayetano(Persona):- 
	tieneCerca(Persona,_),
	forall(tieneCerca(Persona,Cercano),encargo(Persona,Cercano,_)).
	
nivelDeRespeto(Personaje,Nivel):- 
	personaje(Personaje,actriz(Peliculas)),
	length(Peliculas,CantidadDePeliculas),
	Nivel is CantidadDePeliculas / 10.
nivelDeRespeto(Personaje,10):- 
	personaje(Personaje,mafioso(resuelveProblemas)).
nivelDeRespeto(Personaje,20):- 
	personaje(Personaje,mafioso(capo)).
nivelDeRespeto(vincent,15).

%agregado para respetabilidad2
nivelDeRespeto(Personaje,0):- 
	personaje(Personaje,_).

esRespetable(Personaje):-
	nivelDeRespeto(Personaje,Nivel),
	Nivel > 9.

%% agreado para respetabilidad2
noRespetable(Personaje):-	
	nivelDeRespeto(Personaje,Nivel),
	not(esRespetable(Personaje)),
	Nivel < 9.
	
%% agreado para respetabilidad2	
sinRepeticion([X],[X]).
sinRepeticion([X|XS],[X|ListaSinRepetidos]):- 
	not(member(X,XS)),
	sinRepeticion(XS,ListaSinRepetidos).
sinRepeticion([X|XS],ListaSinRepetidos):- 
	member(X,XS),
	sinRepeticion(XS,ListaSinRepetidos).

respetabilidad(Respetables,NoRespetables):-
	findall(Personaje,esRespetable(Personaje),PersonajesRespetables),
	length(PersonajesRespetables,Respetables),
	findall(Personaje2,personaje(Personaje2,_),PersonajesTotales),
	length(PersonajesTotales,CantPersonajesTotales),
	NoRespetables is CantPersonajesTotales-Respetables.
	
respetabilidad2(Respetables,NoRespetables):-
	findall(Personaje,esRespetable(Personaje),PersonajesRespetables),
	length(PersonajesRespetables,Respetables),
	findall(Personaje2,noRespetable(Personaje2),PersonajesNoRespetables),
	sinRepeticion(PersonajesNoRespetables,PersonajesNoRespetablesSinRepeticion),
	length(PersonajesNoRespetablesSinRepeticion,NoRespetables).
	
cantidadDeEncargos(Personaje,CantidadDeEncargos):-
	personaje(Personaje,_),
	findall(Encargo ,encargo(_,Personaje, Encargo),Encargos),
	length(Encargos,CantidadDeEncargos).
	
masAtareado(Personaje):-
	cantidadDeEncargos(Personaje,CantidadDeEncargos),
	forall(cantidadDeEncargos(_,CantidadDeEncargos2),
	CantidadDeEncargos>=CantidadDeEncargos2).

% Otra Forma
masAtareado2(Personaje):-
	cantidadDeEncargos(Personaje,CantidadDeEncargos),
	not((cantidadDeEncargos(_,CantidadDeEncargos2), CantidadDeEncargos2 > CantidadDeEncargos)).
	
/*  Se nos complico encarar respetabilidad con not(esRespetable(Persona),esRespetable es inversible pero con el not ya no lo es dado 
que no viene ligado. Entonces definimos noRespetable y debimos agregar cosas para que nos de lo esperado.

	nivelDeRespeto(Personaje,0):- 
	personaje(Personaje,_). 	

Hace que los personajes tengan nivel 0 y los respetables tambien entran aca.Entonces en noRespetable se agrega not(esRespetable).
Esto lo agregamos nosotros pero si tenemos en cuenta el item 4 del punto 3 no debería ser asi dado que dice que para el resto de 
personajes no se cuenta con un nivel de respeto.

sinRepeticion es necesario porque hay personas que no son respetables por distintos motivos, por ej mia solo hizo una pelicula y 
si nivel de respeto es 0.1 y ademas con el agregado que hicimos su nivel de respeto tambien es 0, entonces aparecería 2 veces en
la lista ( cosa que no queremos). */
