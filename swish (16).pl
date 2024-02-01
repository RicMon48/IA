% Cannibals and missionaries
% 3 cannibals and 3 missionaries, 1 boat
% the boat can take 2 people to the other side
% one needs to be back to the boat to the initial side to take others or change places
% the number of cannibals in each side would be less than the number of missionaries

%Common way to solve the problem is writing as instructions the solution of the problem.
action(initial,otherside):-
    write('Move one cannibal and one missionary to the other side'),
    nl,
    write('Move one missionary to the initial side'),
    nl,
	write('Move two cannibals to the other side'),
	nl,
    write('Move one cannibal to the initial side'),
    nl,
    write('Move two missionaries to the other side'),
    nl,
    write('Move one cannibal to the initial side'),
    nl,
    write('Move two cannibals to the other side'),
    nl,
    write('Move one missionary to the initial side'),
    nl,
    write('Move one missionary and one cannibal to the other side'),
    nl.

:-initialization(main). %call main
main:-action(initial,otherside).