%We want this model to solve the problem
solution(Solution):-
    write("The side A is the initial side and the side B is the other side"),
    nl,
    write("The parameters of the boat are (missionaries,cannibals, side to go)"),
    nl,
    initial(Initial),
    final(Final),
    path(Initial, Solution, Final).


%MA means missionaries from the side A
%CA means cannibals from the side A
%MB means missionaries from the side B
%CB means cannibals from the side B
%And also to represent the side is better with the A and B
%move(MA,CA,MB,CB,A/B)

%As a fact we have that the 3 cannibals and the 3 missionaries are at the A side
initial(move(3,3,0,0,a)).

%Other fact is that we want them in the B side.
final(move(0,0,3,3,b)).

%The rule explains that the path try to solve the problem but this part specifically from the beginning
path(Initial, Path, Final) :-
    %In the instructions we want to express that the first path do not visited other paths.
    %That is why we put a [] that marks that the visited paths are empty and make a vector of.
    %path solutions visited.
	path(Initial, Path, Final, []).

%The use of this path is when the solution to pass from the initial to the final is at one step
path(Initial, [Crossing], Final, _) :-
    %Is necessary to valid the path and that is why we valid the path here
	valid(Crossing, Initial, Final).

%This is the general idea of the path, where we use an intermediate solution
path(Initial, [Crossing| Rest], Final, Visited) :-
    %First we need to valid the use of this path
	valid(Crossing, Initial, Intermediate),
    %Then check the vector of the previous path used
	noin(Intermediate, Visited),
    %We need to check the part from the intermediate part to the other side
    %The path will be saved in the visited vector.
	path(Intermediate, Rest, Final, [Initial | Visited]).

%The paths needs to be valid
%Each validation is for the rule of the boat

%This one is for one missionary in the boat from the B side to the A side
valid(boat(1,0, a),
	move(MA,CA,MB,CB, b),
	move(NA,CA,NB,CB, a)) :-
    %The rule will subtract one missionary from the B side.
	NB is MB - 1,
    %The rule will add one missionary to the A side.
	NA is MA + 1,
    %Then we need to check if the number of missionaries in the b side is positive.
    %To check if there are a missionaries to send.
	NB >= 0,
    %Check if the number of missionaries in the A side is equal or less than 3.
    %To verify if there are some missionaries in the A side.
	NA =< 3,
    %This rules explains if the number of missionaries is lower than the number of cannibals or 
    %if the number of missionaries is cero.
    %Because if the number of missionaries is lower we lose 
	(NA = 0 ; NA >= CA),
	(NB = 0 ; NB >= CB).

%This one is for one missionary in the boat from the A side to the B side
valid(boat(1,0, b),
	move(MA,CA,MB,CB, a),
	move(NA,CA,NB,CB, b)) :-
    %The rule will subtract one missionary from the A side.
	NA is MA - 1,
    %The rule will add one missionary to the B side.
	NB is MB + 1,
    %To check if there are a missionaries to send.
	NA >= 0,
    %To verify if there are some missionaries in the B side.
	NB =< 3,
    %This rules explains if the number of missionaries is lower than the number of cannibals or 
    %if the number of missionaries is cero.
    %Because if the number of missionaries is lower we lose
	(NA = 0; NA >= CA),
	(NB = 0; NB >= CB).

%This one is for one cannibal in the boat from the B side to the A side
valid(boat(0,1, a),
	move(MA,CA,MB,CB, b),
	move(MA,DA,MB,DB, a)) :-
    %The rule will subtract one cannibal from the B side.
	DB is CB - 1,
    %The rule will add one cannibal to the A side.
	DA is CA + 1,
    %To check if there are a cannibals to send.
	DB >= 0,
    %To verify if there are some cannibals in the A side.
	DA =< 3,
    %To check if the number of missionaries is bigger than the number of cannibals
	(MA = 0; MA >= DA),
	(MB = 0; MB >= DB).

%The same for the B side with one cannibal
valid(boat(0,1, b),
	move(MA,CA,MB,CB, a),
	move(MA,DA,MB,DB, b)) :-
	DA is CA - 1,
	DB is CB + 1,
	DA >= 0,
	DB =< 3,
	(MA = 0; MA >= DA),
	(MB = 0; MB >= DB).

%here is for two missionaries in the boat to the A side
valid(boat(2,0, a),
	move(MA,CA,MB,CB, b),
	move(NA,CA,NB,CB, a)) :-
    %Subtract from the number of missionaries of the B side
	NB is MB - 2,
    %Adding two missionaries to the A side
	NA is MA + 2,
    %To check if there are missionaries in the B side
	NB >= 0,
    %To check if in the A side have three o less missionaries
	NA =< 3,
    %To compare the number the number of cannibals and the number of missionaries
	(NA = 0; NA >= CA),
	(NB = 0; NB >= CB).

%Two missionaries to the B side
valid(boat(2,0, b),
	move(MA,CA,MB,CB, a),
	move(NA,CA,NB,CB, b)) :-
    %Same logic
	NA is MA - 2,
	NB is MB + 2,
	NA >= 0,
	NB =< 3,
	(NA = 0; NA >= CA),
	(NB = 0; NB >= CB).

%Two cannibals to the A side
valid(boat(0,2, a),
	move(MA,CA,MB,CB, b),
	move(MA,DA,MB,DB, a)) :-
    %Same logic
	DB is CB - 2,
	DA is CA + 2,
	DB >= 0,
	DA =< 3,
	(MA= 0; MA >= DA),
	(MB = 0; MB >= DB).

%Two cannibals to the B side
valid(boat(0,2, b),
	move(MA,CA,MB,CB, a),
	move(MA,DA,MB,DB, b)) :-
    %Same logic
	DA is CA - 2,
	DB is CB + 2,
	DA >= 0,
	DB =< 3,
	(MA = 0; MA >= DA),
	(MB = 0; MB >= DB).

%One missionary and one cannibal to the A side
valid(boat(1,1, a),
	move(MA,CA,MB,CB, b),
	move(NA,DA,NB,DB, a)) :-
    %Subtract one of each type from the B side
	NB is MB - 1,
	DB is CB - 1,
    %Add one of each type to the A side
	NA is MA + 1,
	DA is CA + 1,
    %Check if there are positive number of each one in the B side
	NB >= 0,
	DB >= 0,
    %Check if in the A side have missionaries and cannibals about
	NA =< 3,
	DA =< 3,
    %Checking the number the cannibals to be lower
	(NA = 0; NA >= DA),
	(NB = 0; NB >= DB).

%One missionary and one cannibal to the B side
valid(boat(1,1, b),
	move(MA,CA,MB,CB, a),
	move(NA,DA,NB,DB, b)) :-
    %Same logic
	NA is MA - 1,
	DA is CA - 1,
	NB is MB + 1,
	DB is CB + 1,
	NA >= 0,
	DA >= 0,
	NB =< 3,
	DB =< 3,
	(NA = 0; NA >= DA),
	(NB = 0; NB >= DB).

%This fact is to say that the list is empty and the symbol _
%says that anything is not in the empty list.
noin(_, []).

%The other part is to verify that if the list is not empty
%The path is not in the list of the visited solutions.

noin(X, [Y | Rest]) :-
	X \= Y,
	noin(X, Rest).