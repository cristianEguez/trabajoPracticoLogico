pareja(marsellus, mia).
pareja(pumkin, honeyBunny).
pareja(bernardo, bianca).
pareja(bernardo, charo).

%trabajaPara(Empleador, Empleado)
trabajaPara(marsellus, vincent).
trabajaPara(marsellus, jules).
trabajaPara(marsellus, winston).
trabajaPara(Empleador,bernardo):- trabajaPara(marsellus,Empleador),Empleador \= jules.
trabajaPara(Empleador,george):- saleCon(bernardo,Empleador).

saleCon(Persona,OtraPersona):- pareja(Persona,OtraPersona). % No es recursiva.
saleCon(Persona,OtraPersona):- pareja(OtraPersona,Persona).

esFiel(Persona):- 
	saleCon(Persona,Alguien1),
	not((saleCon(Persona,Alguien2),Alguien1\=Alguien2)).
	
acataOrden(Empleador,Empleado):- trabajaPara(Empleador,Empleado). % Caso base
acataOrden(Empleador,Empleado):- trabajaPara(Empleador,Intermedio),acataOrden(Intermedio,Empleado). % Caso recursivo

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

esRespetable(Personaje):-
	nivelDeRespeto(Personaje,Nivel),
	Nivel > 9.

respetabilidad(Respetables,NoRespetables):-
	findall(Personaje,esRespetable(Personaje),PersonajesRespetables),
	length(PersonajesRespetables,Respetables),
	findall(Personaje2,personaje(Personaje2,_),PersonajesNoRespetables),
	length(PersonajesNoRespetables,CantNoRespetables),
	NoRespetables is CantNoRespetables-Respetables.

cantidadDeEncargos(Personaje,CantidadDeEncargos):-
	personaje(Personaje,_),
	findall(_,encargo(_,Personaje,_),Encargos),
	length(Encargos,CantidadDeEncargos).
	
masAtareado(Personaje):-
	cantidadDeEncargos(Personaje,CantidadDeEncargos),
	forall(cantidadDeEncargos(_,CantidadDeEncargos2),
	CantidadDeEncargos>=CantidadDeEncargos2).
