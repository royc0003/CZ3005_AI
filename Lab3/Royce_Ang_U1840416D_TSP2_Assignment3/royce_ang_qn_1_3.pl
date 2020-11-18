%fact
competitor(sumsum,appy).
company(sumsum).
company(appy).
developed(sumsum,galatica-s3).
smartphonetech(galatica-s3).
boss(stevey).

%rule
steal(stevey,X,sumsum) :- smartphonetech(X), developed(sumsum,X).
business(X) :- smartphonetech(X).
rival(X):- competitor(X,appy).
unethical(X) :- boss(X), business(Y), rival(Z), company(Z), steal(X,Y,Z).


