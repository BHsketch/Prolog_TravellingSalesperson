% declaring atoms as dynamic allows us to make changes to them at runtime through statements like assert and retract
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

% ------- BASE AND RECURSIVE CASES FOR PRINTING ELEMENTS IN A LIST (Was required mainly for debugging) -------
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

% ------- OVERLOAD FOR THE TRAVEL FUNCTION THAT THE USER CALLS -------
% This overload will create the necessary non-backtrackable variables required to maintain the following state information:
% 1. number of nodes in the graph --- numOfNodes
% 2. the shortest path so far --- shortestPath --- stored in a non-backtrackable variable
% 3. the shortest path length so far --- shortestPathLength --- stored in a non-backtrackable variable
% 4. Cost of the Current path we're on --- CurrentPathCost --- stored as a backtrackable variable, because we want changes (addition of iterative costs) to be reversed when we backtrack and take another path
travel(Start, End, PathSoFar) :-
	nb_setval(numOfNodes, 7),
	nb_setval(shortestPathCost, 1000), % setting some arbitrarily high initial value for shortestPathLength
	nb_setval(shortestPath, [j, k, l, m, n, o, p, q]), % empty list as initial value for shortests path
	b_setval(currentPathCost, 0),

	travel(Start, End, PathSoFar, numOfNodes, shortestPathCost, shortestPath, currentPathCost),

	%write(' shortest path: '),
	nb_getval(shortestPath, ShortestPath),
	asserta(shortestPath(ShortestPath)).
	%print_list(ShortestPath).


% ------- BASE AND RECURSIVE CASES FOR TRAVELLING BETWEEN TWO NODES -------
travel(Start, End, PathSoFar, numOfNodes, shortestPathCost, shortestPath, currentPathCost) :-
	% Base case for travel: Start is the second-last node and End is the destination
	% First append End to the PathSoFar variable
	path(Start, End, Cost), 
	not(member(End, PathSoFar)),
	append(PathSoFar, [End], PathSoFar1),

	% Then check if the path is passing through all nodes (check its length)
	length(PathSoFar1, PathSoFar1Length),
	nb_getval(numOfNodes, NumberOfNodes),
	PathSoFar1Length =:= NumberOfNodes,
	
	%write('hi1'),
	% Consider this solution only if it has total costs lesser than shortestPathCost
	b_getval(currentPathCost, CurrentPathCost),
	nb_getval(shortestPathCost, ShortestPathCost),
	UpdatedPathCost is CurrentPathCost + Cost,
	b_setval(currentPathCost, UpdatedPathCost),
	
	% if so, update ShortestPathCost and ShortestPath values
	UpdatedPathCost @< ShortestPathCost, 
	%ShortestPathCost is UpdatedPathCost,
	nb_setval(shortestPathCost, UpdatedPathCost),
	nb_setval(shortestPath, PathSoFar1).


travel(Start, End, PathSoFar, numOfNodes, shortestPathCost, shortestPath, currentPathCost) :-
	%format('recursive case travel with Start = ~w, End = ~w, and PathSoFar = ~w', [Start, End, PathSoFar]),
	%nl,
	% If no direct path exist between Start and End, Consider paths between Start and it's neighbours, 
	% Add this neighbor to PathSoFar if not already there (avoiding loops), 
	% update the current path cost
	% and then recursively calculate the paths between that neighbour and End.
	path(Start, Neigh, Cost), 
	not(member(Neigh, PathSoFar)),
	append(PathSoFar, [Neigh], PathSoFar1),	

	b_getval(currentPathCost, CurrentPathCost),
	UpdatedPathCost is CurrentPathCost + Cost,
	b_setval(currentPathCost, UpdatedPathCost),

	travel(Neigh, End, PathSoFar1, numOfNodes, shortestPathCost, shortestPath, currentPathCost).

