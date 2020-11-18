% Begin with dynamic initialization
:- dynamic count_acne/1.
:- dynamic count_flu/1.
:- dynamic count_allergy/1.
:- dynamic count_covid_19/1.
:- dynamic count_heart_disease/1.
:- dynamic count_high_blood_sugar/1.
:- dynamic count_cancer/1.
:- dynamic pain_questions/1.
:- dynamic pain/1.
:- dynamic all_reactions/1.
:- dynamic symptoms/1.


%----------------------------------------------------------------------------------------------------------
%Common Controls Functions
%Important functions to control list
/* Check if X is a member of the list.
   1. Check if X is in the head of the list
   2. If no, do a recursion and check if X is in the tail of the list
   3. If eventually the tail is empty, X is not in the lsit */
member(X,[X|_]).
member(X,[_|R]) :- member(X,R).

/* takeout a member from a list
   1. Check if the target is at the head of the list, if yes, takeout
   2. If no, do a recursion on the tail until the list is empty.*/
takeout(X,[X|R],R).
takeout(X,[F|R],[F|S]) :- takeout(X,R,S).
%checks ([a|tail],a,tail); a = a   & tail = tail
%

/* append a member to a list*/
append([A | B], C, [A | D]) :- append(B, C, D).
append([], A, A).

%----------------------------------------------------------------------------------------------------------
% Disease 
% 7 different diseases with its 7 associated symptoms
/*Symptoms for Acne*/
acne([lump, whiteheads, blackheads, pus, cyst, scar]).

/*Symptoms for Flu*/
flu([cough, runny_nose,  ache, weak, tired, fever]).

/*Symptoms for Allergy*/
allergy([cough, runny_nose, rash, wheeze, sneeze, red_eye]).  

/*Symptoms for Covid-19*/
covid_19([fever, tired, cough, rash, wheeze, loss_of_speech]).

/*Symptoms for Heart Disease*/
heart_disease([tired,weight_loss, no_appetite, leg_swell, chest_pain, breathless]).

/*Symptoms for High Blood Sugar*/
high_blood_sugar([infection, weight_loss, pee_frequently, thirst, blur_vision, dry_mouth]).

/*Symptoms for Cancer*/
cancer([tired, infection, lump, pale_skin, bleed, breathless]).

%functions related to symptoms
/* Flattens all the symptoms into a super list L without duplicates*/
unique_symptoms(L) :- acne(A), flu(B), allergy(C), covid_19(D), heart_disease(E), high_blood_sugar(F), cancer(G), flatten([A, B, C, D, E, F, G], X), sort(X, L).

/* Initialize a list of symptoms to query */
symptoms(L) :- unique_symptoms(L).

%----------------------------------------------------------------------------------------------------------
%Counter Increment Functions
%Increasing dynamic count for all disease
/*
1. Retrieve current value of disease_count and store as V0.
2. Reset the current value of disease_count to 0.
3. Increase current stored value of V0 and store in V.
4. Set current value of disease_count to V.
*/
/* Fever */
add_count_acne :-
    count_acne(V0),
    retractall(count_acne(_)),
    succ(V0, V),
    assertz(count_acne(V)).

/* Cold */
add_count_flu :-
    count_flu(V0),
    retractall(count_flu(_)),
    succ(V0, V),
    assertz(count_flu(V)).

/* Infection */
add_count_allergy :-
    count_allergy(V0),
    retractall(count_allergy(_)),
    succ(V0, V),
    assertz(count_allergy(V)).

/* Injury */
add_count_covid_19 :-
    count_covid_19(V0),
    retractall(count_covid_19(_)),
    succ(V0, V),
    assertz(count_covid_19(V)).

/* Chicken Pox */
add_count_heart_disease :-
    count_heart_disease(V0),
    retractall(count_heart_disease(_)),
    succ(V0, V),
    assertz(count_heart_disease(V)).

/* Appendicitis */
add_count_high_blood_sugar :-
    count_high_blood_sugar(V0),
    retractall(count_high_blood_sugar(_)),
    succ(V0, V),
    assertz(count_high_blood_sugar(V)).

/* Mild Stroke*/
add_count_cancer :-
    count_cancer(V0),
    retractall(count_cancer(_)),
    succ(V0, V),
    assertz(count_cancer(V)).

%----------------------------------------------------------------------------------------------------------
%Patient's Pain 
% All levels of pain
pain_knowledge([pain_free, mild_pain, moderate_pain, severe_pain, overwhelming_pain]).

pain_questions(['Do you feel mild pain?','Do you feel moderate pain?', 'Do you feel severe pain?', 'Do you feel overwhelmingly severe pain?']).

/* Queries for Degree of Pain */
/* 1. Take out head of the list. 
   2. Update the pain_question to the tail of the list, 
      this can be done by reseting pain_questions and assert the tail. 
   3. Ask the question again.
*/
pain_query(X) :- pain_questions([X|T]), takeout(X, [X|T], T), (retractall(pain_questions(_)), assertz(pain_questions(T))), ask_repeat(X). 

/*Error handling -> pain_query list is now empty, and to prevent error, just treat as common flu*/
pain_query([]) :- (assert(pain(pain_free)), add_count_flu, query_symptoms(_)).


/*Confirm pain level and assert*/
confirm_pain(mild_pain) :- assert(pain(mild_pain)), add_count_acne, add_count_allergy.
confirm_pain(moderate_pain) :- assert(pain(moderate_pain)), add_count_high_blood_sugar, add_count_covid_19.
confirm_pain(severe_pain) :- assert(pain(severe_pain)), add_count_heart_disease.
confirm_pain(overwhelming_pain) :- assert(pain(overwhelming_pain)),add_count_cancer.
confirm_pain(pain_free) :- assert(pain(pain_free)) , add_count_flu.

%----------------------------------------------------------------------------------------------------------
% Patient's Mood Knowledge

mood(calm) :- pain(pain_free).
mood(worried) :- pain(mild_pain).
mood(stressed) :- pain(moderate_pain).
mood(fearful) :- pain(severe_pain).
mood(panic_stricken) :- pain(overwhelming_pain).

%----------------------------------------------------------------------------------------------------------
%Doctor's Reaction Knowledge

/*Lists of possible speeches*/
emoticons(['^_^',':D',':O','^^',':)']).
filler_words(['Interesting...','Hmm...','That being said.','Um...','Uh..huh..','Fascinating...','Oh I see...']).
kidding(['The cost will be 1 million. Just kidding.','How many days of MC do you need? Just kidding.','An apple a day keeps the doctor away. Here is one for u.','Where is my Google? Just kidding.','Do you want lollipop?']).
knoweldgable(['I have seen this many times.','This is very common.','This is not out of this world.','Why am I not surprised.']).
companion(['We are in the same boat.','Let us go through this together.','You are not alone.','Let us stand strong together.','Together we can.']).
reassure(['Like yourself, I have been through this before.','Do not worry.','Do not fear.','I understand.']).
relax(['Take deep breaths.','Cheer up my friend.','Be happy','Be grateful','Stay cheerful','Life is precious']).
attentive(['My ears are wide open for you.','Yes, I am listening please continue.','Your words are equally important to me.','*Looks Attentive*']).
inspiring_quote(['True beauty is a warm heart, a kind soul, and an attentive ear from me.','However much you might watch me I should be watching you more.','It is going to be ok in the end. If it is not ok, it is not the end.']).

/* Flattens all applicable gesture into a super list L without duplicates */
all_reactions(L) :- mood(calm), knoweldgable(A), emoticons(B), kidding(C), filler_words(D), flatten([A, B, C, D], X), sort(X, L).
all_reactions(L) :- mood(worried), knoweldgable(A), reassure(B), kidding(C), filler_words(D), flatten([A, B, C, D], X), sort(X, L).
all_reactions(L) :- mood(stressed), reassure(A), emoticons(B), relax(C), filler_words(D), flatten([A, B, C, D], X), sort(X, L).
all_reactions(L) :- mood(fearful), reassure(A), relax(B), filler_words(C), knoweldgable(D), flatten([A, B, C, D], X), sort(X, L).
all_reactions(L) :- mood(panic_stricken), attentive(A), companion(B), inspiring_quote(C), reassure(D), flatten([A, B, C, D], X), sort(X, L).

/*Picks a random reaction from a list of reactions*/
random_reaction(X) :- all_reactions(L), random_member(X,L).

/*Plays the chosen reaction, remove the used reaction and updates*/
reaction :- random_reaction(X), print(X), all_reactions(L), select(X, L, T), retractall(all_reactions(_)), assertz(all_reactions(T)).

%----------------------------------------------------------------------------------------------------------
% (Main Function)

ask(0) :- 
    print('안녕! Hello! Do you feel any pain?'),
    print('y/n: '),
    read(Answer),
    (Answer==y -> pain_query(_);
    Answer==n -> confirm_pain(pain_free), query_symptoms(_)).

ask_repeat(X) :-
    print(X),
    print('y/n: '),
    read(Answer),
    (Answer==y -> ((X == 'Do you feel mild pain?') -> (confirm_pain(mild_pain), query_symptoms(_)) ;
                (X == 'Do you feel moderate pain?') -> (confirm_pain(moderate_pain), query_symptoms(_)) ;
                (X == 'Do you feel severe pain?') -> (confirm_pain(severe_pain), query_symptoms(_)) ;
                (X == 'Do you feel overwhelmingly severe pain?') -> (confirm_pain(overwhelming_pain), query_symptoms(_))) ;
    Answer==n -> pain_query(_)).


%----------------------------------------------------------------------------------------------------------
% Querying symptoms

random_symptom(X) :- symptoms(L), random_member(X, L).

/* Query the user based on the randomly removed element from the symptom list
    If user has that symptom, assert that symptom and increnment the relevant count. E.g if user has ache, increment count for fever
    If user doesnt have that symptom, continue to query until the list is empty.
*/
query_symptoms(X) :- random_symptom(X), 
                    (X==lump -> reaction, print('Do you have any lump?'), print('y/n: '), read(Answer), (Answer==y -> merge(lump) ; Answer==n );
                     X==whiteheads -> reaction, print('Do you have any whitehead?'), print('y/n: '), read(Answer), (Answer==y -> merge(whiteheads) ; Answer==n );
                     X==blackheads -> reaction, print('Do you have any blackhead?'), print('y/n: '), read(Answer), (Answer==y -> merge(blackheads) ; Answer==n );
                     X==pus -> reaction, print('Did you secrete pus?'), print('y/n: '), read(Answer), (Answer==y -> merge(pus) ; Answer==n );
                     X==cyst -> reaction, print('Do you have any cyst?'), print('y/n: '), read(Answer), (Answer==y -> merge(cyst) ; Answer==n );
                     X==scar -> reaction, print('Do you have any scar?'), print('y/n: '), read(Answer), (Answer==y -> merge(scar) ; Answer==n );
                     X==cough ->reaction, print('Do you have cough'), print('y/n: '), read(Answer), (Answer==y -> merge(cough) ; Answer==n );
                     X==runny_nose -> reaction, print('Are you having runny nose?'), print('y/n: '), read(Answer), (Answer==y -> merge(runny_nose) ; Answer==n );
                     X==ache -> reaction, print('Did you have ache?'), print('y/n: '), read(Answer), (Answer==y -> merge(ache) ; Answer==n );
                     X==weak -> reaction, print('Do you feel that your body is weak?'), print('y/n: '), read(Answer), (Answer==y -> merge(weak) ; Answer==n );
                     X==tired -> reaction, print('Do you feel perpetually tired?'), print('y/n: '), read(Answer), (Answer==y -> merge(tired) ; Answer==n );
                     X==fever -> reaction, print('Do you have a fever?'), print('y/n: '), read(Answer), (Answer==y -> merge(fever) ; Answer==n );
                     X==rash -> reaction, print('Do you have any rash?'), print('y/n: '), read(Answer), (Answer==y -> merge(rash) ; Answer==n );
                     X==wheeze -> reaction, print('Are you wheezing?'), print('y/n: '), read(Answer), (Answer==y -> merge(wheeze) ; Answer==n );
                     X==sneeze -> reaction, print('Do you sneeze frequently?'), print('y/n: '), read(Answer), (Answer==y -> merge(sneeze) ; Answer==n );
                     X==red_eye -> reaction, print('Do you have red eyes ?'), print('y/n: '), read(Answer), (Answer==y -> merge(red_eye ) ; Answer==n );
                     X==loss_of_speech -> reaction, print('Do you sometimes experience loss of speech?'), print('y/n: '), read(Answer), (Answer==y -> merge(loss_of_speech) ; Answer==n );
                     X==no_appetite -> reaction, print('Did you experience lack of appetite?'), print('y/n: '), read(Answer), (Answer==y -> merge(no_appetite) ; Answer==n );
                     X==leg_swell ->reaction, print('Do you have swelling on your leg?'), print('y/n: '), read(Answer), (Answer==y -> merge(leg_swell) ; Answer==n );
                     X==chest_pain -> reaction, print('Do you have any chest pain ?'), print('y/n: '), read(Answer), (Answer==y -> merge(chest_pain ) ; Answer==n );
                     X==weight_loss -> reaction, print('Do you experience drastic weight loss?'), print('y/n: '), read(Answer), (Answer==y -> merge(weight_loss) ; Answer==n );
                     X==pee_frequently-> reaction, print('Did you have to use the bathroom frequently?'), print('y/n: '), read(Answer), (Answer==y -> merge(pee_frequently) ; Answer==n );
                     X==thirst -> reaction, print('Do you always feel thirsty?'), print('y/n: '), read(Answer), (Answer==y -> merge(thirst) ; Answer==n );
                     X==blur_vision -> reaction, print('Do you have any blur vision?'), print('y/n: '), read(Answer), (Answer==y -> merge(blur_vision) ; Answer==n );
                     X==dry_mouth -> reaction, print('Do you have a dry mouth?'), print('y/n: '), read(Answer), (Answer==y -> merge(dry_mouth) ; Answer==n );
                     X==infection -> reaction, print('Do you have any infection?'), print('y/n: '), read(Answer), (Answer==y -> merge(infection) ; Answer==n );
                     X==pale_skin -> reaction, print('Do you sometimes have pale skin?'), print('y/n: '), read(Answer), (Answer==y -> merge(pale_skin) ; Answer==n );
                     X==breathless -> reaction, print('Did you experience breathlessness?'), print('y/n: '), read(Answer), (Answer==y -> merge(breathless) ; Answer==n );
                     X==bleed -> reaction, print('Do you often bleed?'), print('y/n: '), read(Answer), (Answer==y -> merge(bleed) ; Answer==n )
                    )
                    , symptoms(L), select(X, L, T), retractall(symptoms(_)), assertz(symptoms(T)), query_symptoms(_).

/* If the list is empty, diagnose the user */
query_symptoms([]) :- diagnosis.


 /* Combine assertion and incrementation into a single rule */
/* Used when the user has the symptoms 
   1. Assert has(Symptom)
   2. Increment relevant counter associated with that symptom */
merge(lump) :- (assert(has(lump)), incr_lump).
merge(whiteheads) :- (assert(has(whiteheads)), incr_whiteheads).
merge(blackheads) :- (assert(has(blackheads)), incr_blackheads).
merge(pus) :- (assert(has(pus)), incr_pus).
merge(cyst) :- (assert(has(cyst)), incr_cyst).
merge(scar) :- (assert(has(scar)), incr_scar).
merge(cough) :- (assert(has(cough)), incr_cough).
merge(runny_nose) :- (assert(has(runny_nose)), incr_runny_nose).
merge(ache) :- (assert(has(ache)), incr_ache).
merge(weak) :- (assert(has(weak)), incr_weak).
merge(tired) :- (assert(has(tired)), incr_tired).
merge(fever) :- (assert(has(fever)), incr_fever).
merge(rash) :- (assert(has(rash)), incr_rash).
merge(rash) :- (assert(has(rash)), incr_rash).
merge(wheeze) :- (assert(has(wheeze)), incr_wheeze).
merge(sneeze) :- (assert(has(sneeze)), incr_sneeze).
merge(red_eye) :- (assert(has(red_eye)), incr_red_eye).
merge(loss_of_speech) :- (assert(has(loss_of_speech)), incr_loss_of_speech).
merge(no_appetite) :- (assert(has(no_appetite)), incr_no_appetite).
merge(leg_swell) :- (assert(has(leg_swell)), incr_leg_swell).
merge(chest_pain) :- (assert(has(chest_pain)), incr_chest_pain).
merge(weight_loss) :- (assert(has(weight_loss)), incr_weight_loss).
merge(pee_frequently) :- (assert(has(pee_frequently)), incr_pee_frequently).
merge(thirst) :- (assert(has(thirst)), incr_thirst).
merge(blur_vision) :- (assert(has(blur_vision)), incr_blur_vision).
merge(infection) :- (assert(has(infection)), incr_infection).
merge(pale_skin) :- (assert(has(pale_skin)), incr_pale_skin).
merge(breathless) :- (assert(has(breathless)), incr_breathless).
merge(dry_mouth) :- (assert(has(bruise)), incr_dry_mouth).
merge(bleed) :- (assert(has(bleed)), incr_bleed).



%----------------------------------------------------------------------------------------------------------
% Heuristic to add weights to symptoms
% We know that symptoms of acne is unique, no need for additional weights.
% In the scenario where we have 2 disease having the same symptom, then the weight for symptoms unique to that disease should be x2.
% lump (acne, cancer)
incr_lump :- (add_count_acne, add_count_cancer).
incr_whiteheads :- add_count_acne, add_count_acne.
incr_blackheads :- add_count_acne, add_count_acne.
incr_pus :- add_count_acne, add_count_acne.
incr_cyst :- add_count_acne, add_count_acne.
incr_scar :- add_count_acne, add_count_acne.

%cough (flue, allergy, covid-19)
incr_cough :- (add_count_flu, add_count_allergy, add_count_covid_19).

%runny_nose(flu, allergy)
incr_runny_nose :- (add_count_flu, add_count_allergy).
%ache x2
incr_ache :- add_count_flu, add_count_flu.
%weak x2
incr_weak :- add_count_flu, add_count_flu.
%fever x2
incr_fever :- add_count_flu, add_count_flu.
%tired(flu, covid-19, cancer, heart disease)
incr_tired :- (add_count_flu, add_count_covid_19, add_count_cancer, add_count_heart_disease).
%rash (allergy, covid-19
incr_rash :- (add_count_allergy, add_count_covid_19).
%wheeze (allergy, covid_19)
incr_wheeze :- (add_count_allergy, add_count_covid_19).
%sneeze x2
incr_sneeze :- add_count_allergy, add_count_allergy.
%red_eye x2
incr_red_eye :- add_count_allergy, add_count_allergy.
%loss of speech x2
incr_loss_of_speech :- add_count_covid_19, add_count_covid_19.

%no_appetite x2
incr_no_appetite :- add_count_heart_disease, add_count_heart_disease.
incr_leg_swell :- add_count_heart_disease, add_count_heart_disease.
incr_chest_pain :- add_count_heart_disease, add_count_heart_disease.
%breathles (hear disease, cancer)
incr_breathless :- (add_count_heart_disease, add_count_cancer).

%high blood sugar (hbs, cancer)
incr_infection:- (add_count_high_blood_sugar, add_count_cancer).
incr_weight_loss :- add_count_high_blood_sugar, add_count_high_blood_sugar.
incr_pee_frequently :- add_count_high_blood_sugar, add_count_high_blood_sugar.
incr_thirst :- add_count_high_blood_sugar, add_count_high_blood_sugar.
incr_blur_vision :- add_count_high_blood_sugar, add_count_high_blood_sugar.
incr_dry_mouth :- add_count_high_blood_sugar, add_count_high_blood_sugar.

%cancer
incr_pale_skin :- add_count_cancer, add_count_cancer,add_count_cancer,add_count_cancer.
incr_bleed :- add_count_cancer, add_count_cancer.








%----------------------------------------------------------------------------------------------------------
% Diagnosis
/* Diagnose the result based on count. E.g if count_fever is the largest, then fever will be the diagnosis */
diagnose(acne) :- count_acne(A), count_flu(B), count_allergy(C), count_covid_19(D), count_heart_disease(E), count_high_blood_sugar(F), count_cancer(G),
                    A >= B, A >= C, A >= D, A >= E, A >= F, A >= G.

diagnose(flu) :- count_acne(A), count_flu(B), count_allergy(C), count_covid_19(D), count_heart_disease(E), count_high_blood_sugar(F), count_cancer(G),
                    B >= A, B >= C, B >= D, B >= E, B >= F, B >= G.

diagnose(allergy) :- count_acne(A), count_flu(B), count_allergy(C), count_covid_19(D), count_heart_disease(E), count_high_blood_sugar(F), count_cancer(G),
                    C >= B, C >= A, C >= D, C >= E, C >= F, C >= G.

diagnose(covid_19) :- count_acne(A), count_flu(B), count_allergy(C), count_covid_19(D), count_heart_disease(E), count_high_blood_sugar(F), count_cancer(G),
                    D >= B, D >= C, D >= A, D >= E, D >= F, D >= G.

diagnose(heart_disease) :- count_acne(A), count_flu(B), count_allergy(C), count_covid_19(D), count_heart_disease(E), count_high_blood_sugar(F), count_cancer(G),
                    E >= B, E >= C, E >= D, E >= A, E >= F, E >= G.

diagnose(high_blood_sugar) :- count_acne(A), count_flu(B), count_allergy(C), count_covid_19(D), count_heart_disease(E), count_high_blood_sugar(F), count_cancer(G),
                    F >= B, F >= C, F >= D, F >= E, F >= A, F >= G.

diagnose(cancer) :- count_acne(A), count_flu(B), count_allergy(C), count_covid_19(D), count_heart_disease(E), count_high_blood_sugar(F), count_cancer(G),
                    G >= B, G >= C, G >= D, G >= E, G >= F, G >= A.



diagnosis :- diagnose(acne) -> print('I diagnose that you have an acne.') ;
             diagnose(flu) -> print('I diagnose that you have a flu.') ;
             diagnose(allergy) -> print('I diagnose that you have an allergy.') ;
             diagnose(covid_19) -> print('I am sorry but you have COVID-19.') ;
             diagnose(heart_disease) -> print('I apologize but you have heart disease.') ;
             diagnose(high_blood_sugar) -> print('I diagnose that you have high blood suagar.') ;
             diagnose(cancer) -> print('I regret to inform you that you have cancer.').



%----------------------------------------------------------------------------------------------------------
% initialize all counters
init_count :-
    retractall(count_acne(_)), retractall(count_flu(_)), retractall(count_allergy(_)), retractall(count_covid_19(_)),
    retractall(count_heart_disease(_)), retractall(count_high_blood_sugar(_)), retractall(count_cancer(_)),
    assertz(count_acne(0)), assertz(count_flu(0)), assertz(count_allergy(0)), assertz(count_covid_19(0)), assertz(count_heart_disease(0)),
    assertz(count_high_blood_sugar(0)), assertz(count_cancer(0)).
    
:- init_count.


/*
:- dynamic count_acne/1.
:- dynamic count_flu/1.
:- dynamic count_allergy/1.
:- dynamic count_covid_19/1.
:- dynamic count_heart_disease/1.
:- dynamic count_high_blood_sugar/1.
:- dynamic count_cancer /1.
:- dynamic pain_questions/1.
:- dynamic pain/1.
:- dynamic all_reactions/1.
:- dynamic symptoms/1.

*/




/*
        lump 
        whiteheads 
        blackheads 
        pus 
        cyst 
        scar 
        cough 
        runny_nose 
        ache 
        weak  
        tired
        fever
        rash 
        wheeze 
        sneeze 
        red_eye 
        loss_of_speech 
        no_appetite 
        leg_swell 
        chest_pain 
        weight_loss 
        pee_frequently
        thirst 
        blur_vision
        infection
        pale_skin
        breathless               
        bruise


*/










% % yes(Yes).
% % ok(Answer):- yes(Yes).

% % ask(0):- print('Are you ok?'),read(Answer), ok(Answer).

% fever([temperature, sweat, ache, headache, tiredness, nausea, chills]).

% askFever(X):- fever(X).


% % Note that assert is used to add into database