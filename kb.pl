:- dynamic(path/3).
:- dynamic(visited/1).
:- dynamic(shortestPath/1).
:- dynamic(numberOfNodes/1).


path(a, b, 12).
path(a, c, 10).
path(a, g, 12).

path(b, a, 12).
path(b, c, 8).
path(b, d, 12).

path(d, b, 12).
path(d, c, 11).
path(d, e, 11).
path(d, f, 10).

path(f, g, 9).
path(f, e, 6).
path(f, d, 10).

path(g, a, 12).
path(g, c, 9).
path(g, e, 7).
path(g, f, 9).

path(c, a, 10).
path(c, b, 8).
path(c, d, 11).
path(c, e, 3).
path(c, g, 9).

path(e, c, 3).
path(e, d, 11).
path(e, f, 6).
path(e, g, 7).

% ------- OVERLOAD FOR THE TRAVEL FUNCTION THAT THE USER CALLS -------
% This overload will create the necessary non-backtrackable variables required to maintain the following state information:
% 1. number of nodes in the graph --- numOfNodes
% 2. the shortest path so far --- shortestPath
% 3. the shortest path length so far --- shortestPathLength

travel(Start, End, PathSoFar) :-
	nb_setval(numOfNodes, 7),
	nb_setval(shortestPathLength, 1000), % setting some arbitrarily high initial value for shortestPathLength
	nb_setval(shortestPath, [j, k, l, m, n, o, p, q]), % empty list as initial value for shortests path

	travel(Start, End, PathSoFar, numOfNodes),

	write(' shortest path: '),
	nb_getval(shortestPath, ShortestPath),
	print_list(ShortestPath).

% ------- BASE AND RECURSIVE CASES FOR PRINTING ELEMENTS IN A LIST -------
print_list(List) :-
	length(List, X),
   	X =:= 1,
	[H|_] = List,
	%write('about to print print_list base case'),
	%nl,
	format('-- ~w ', [H]).

print_list(List) :-
	length(List, X),
	X =\= 1,
	[H | T] = List,
	%write('about to print print_list recursive case'),
	%nl,
	format('-- ~w ', [H]),
	print_list(T).

% ------- BASE AND RECURSIVE CASES FOR TRAVELLING BETWEEN TWO NODES -------
travel(Start, End, PathSoFar, numOfNodes) :-
	%format('base case travel with Start = ~w, End = ~w, and PathSoFar = ~w', [Start, End, PathSoFar]),
	%nl,
	% If there exists a direct path between this node (Start) and the finish, take that path. Now PathSoFar is officially
	% the path from Start to End. Hence we can print it.
	path(Start, End, _ ), 
	not(member(End, PathSoFar)),
	append(PathSoFar, [End], PathSoFar1),

	length(PathSoFar1, PathSoFar1Length),
	nb_getval(numOfNodes, NumberOfNodes),
	PathSoFar1Length =:= NumberOfNodes.

	%print_list(PathSoFar1).

travel(Start, End, PathSoFar, numOfNodes) :-
	%format('recursive case travel with Start = ~w, End = ~w, and PathSoFar = ~w', [Start, End, PathSoFar]),
	%nl,
	% If no direct path exist between Start and End, Consider paths between Start and it's neighbours, 
	% Add this neighbor to PathSoFar if not already there (avoiding loops), 
	% and then recursively calculate the paths between that neighbour and End.
	path(Start, Neigh, _), 
	not(member(Neigh, PathSoFar)),
	append(PathSoFar, [Neigh], PathSoFar1),	
	travel(Neigh, End, PathSoFar1, numOfNodes).

