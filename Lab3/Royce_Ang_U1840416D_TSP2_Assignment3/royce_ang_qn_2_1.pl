%facts
male(charles).
male(andrew).
male(edward).
female(ann).
female(elizabeth).
queen(elizabeth).

%relationships
mother(elizabeth, charles).
mother(elizabeth, ann).
mother(elizabeth, andrew).
mother(elizabeth, edward).

older(charles, ann).
older(charles, andrew).
older(charles, edward).
older(ann, andrew).
older(ann, edward).
older(andrew, edward).

% listofchildren(X, List):- findall(X, mother(elizabeth, X), List).

%rules
older_result(X,Y) :- male(X), male(Y), older(X,Y).
older_result(X,Y) :- male(X), female(Y), Y \= elizabeth.
older_result(X,Y) :- female(X), female(Y),older(X,Y).


succession([A|B], Sorted) :- succession(B, SortedTail), insert(A, SortedTail, Sorted).
succession([],[]).
insert(A, [B|C], [B|D]) :- not(older_result(A,B)),!, insert(A, C, D).
insert(A, C, [A|C]).

successionList(X, Succession):-
	findall(Y, mother(X,Y), Children),
	succession(Children, Succession).