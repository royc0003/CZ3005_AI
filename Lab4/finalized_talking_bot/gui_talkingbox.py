from pyswip import Prolog
import pyttsx3
import PySimpleGUI as sg
import random
import asyncio
import time

# Initialization
engine = pyttsx3.init()
prolog = Prolog()
prolog.consult("/Users/royceang/Documents/CZ3005_AI/Lab4/finalized_talking_bot/talking_box.pl")
sentence = 'Hello! I am Doctor Box. Do you feel any pain?'
state = 0
all_gestures = []

class _TTS:
    
    engine = None
    rate = 170
    def __init__(self):
        self.engine = pyttsx3.init()
        self.engine.setProperty("rate", self.rate)


    def start(self,text_):
        self.engine.say(text_)
        self.engine.runAndWait()
        self.engine.stop()

# Set up GUI
# Add a touch of color
sg.theme('DarkAmber')
# Layout of talking box.
layout = [[sg.Text(sentence, key='text', size=(60,3))],
          [sg.Button('Yes'),
           sg.Button('No')]]

# Query Knowledge Base for Symptoms and Pain Questions
q = list(prolog.query("unique_symptoms(L)"))
all_symptoms = (q[0]['L'])
symptoms = all_symptoms
random.shuffle(symptoms)
pain_questions = list(prolog.query("pain_questions(L)"))[0]['L']
mood_questions = list(prolog.query("mood_questions(L)"))[0]['L']

print(str(mood_questions[0]))


# Create the Window
window = sg.Window('Patient with a Sympathetic Doctor', layout)
tts = _TTS()
tts.start(sentence)
del(tts)

# Main logic for the program
# State = 0 : Ask user if any pain
# State = 1 : Ask user for degree of pain
# State = 5 : Ask user for mood level
# State = 2 : Ask user for symptoms
# State = 3 : Diagnose the user
while True:
    if not (state == 2 or state == 3):
        event, values = window.read()
    # if user closes window or clicks cancel
    if event in (None, 'Cancel'):
        break

    if state == 0:
        # If user feels pain, go through the pain questions to figure out the degree of pain
        # Else assert no pain and get relevant gestures
        if event == 'Yes':
            state = 1
            sentence = str(pain_questions.pop(0))
            print("Debugging: "+sentence)
        elif event == 'No':
            state = 5
            list(prolog.query("confirm_pain(pain_free)"))
            print("Asserted pain free")
            #all_gestures = list(prolog.query("all_reactions(L)"))[0]['L']
            #random.shuffle(all_gestures)
            symptom = str(symptoms.pop(0))
            sentence = str(mood_questions.pop(0))
            
            
            

    # Assert the degree of pain according to the user and get relevant gestures
    # If user doesn't choose, default back to no pain and get relevant gestures
    elif state == 1:
        if sentence == 'Do you feel mild pain?':
            if event == 'Yes':
                state = 5
                list(prolog.query("confirm_pain(mild_pain)"))
                print("Asserted mild pain")
                symptom = str(symptoms.pop(0))
                sentence = str(mood_questions.pop(0))

                
            elif event == 'No':
                sentence = str(pain_questions.pop(0))
                

        elif sentence == 'Do you feel moderate pain?':
            if event == 'Yes':
                state = 5
                list(prolog.query("confirm_pain(moderate_pain)"))
                print("Asserted moderate pain")
                symptom = str(symptoms.pop(0))
                sentence = str(mood_questions.pop(0))
                
             
            elif event == 'No':
                sentence = str(pain_questions.pop(0))
                
        elif sentence == 'Do you feel severe pain?':
            if event == 'Yes':
                state = 5
                list(prolog.query("confirm_pain(severe_pain)"))
                print("Asserted severe pain")
                symptom = str(symptoms.pop(0))
                sentence = str(mood_questions.pop(0))
                
            elif event == 'No':
                sentence = str(pain_questions.pop(0))
                
        elif sentence == 'Do you feel overwhelmingly severe pain?':
            if event == 'Yes':
                state = 5
                list(prolog.query("confirm_pain(overwhelming_pain)"))
                print("Asserted overwhelming pain")
                symptom = str(symptoms.pop(0))
                sentence = str(mood_questions.pop(0))
            
                
            elif event == 'No':
                list(prolog.query("confirm_pain(pain_free)"))
                print("Asserted pain free")
                state = 5
                symptom = str(symptoms.pop(0))
                sentence = str(mood_questions.pop(0))
                
    # this state is mainly to query for all questions
    #(1) Assert the mood level
    #(2) Query the appropriate gestures for subsequent states
    elif state == 5:
        if sentence == 'Are you feeling calm?':
            if event == 'Yes':
                state = 2
                list(prolog.query("confirm_mood(calm)"))
                print("Asserted mood(calm)")
                all_gestures = list(prolog.query("all_reactions(L)"))[0]['L']
                random.shuffle(all_gestures)
                
                
            elif event == 'No':
                sentence = str(mood_questions.pop(0))
                
        elif sentence == 'Are you feeling worried?':
            if event == 'Yes':
                state = 2
                list(prolog.query("confirm_mood(worried)"))
                print("Asserted mood(worried)")
                all_gestures = list(prolog.query("all_reactions(L)"))[0]['L']
                random.shuffle(all_gestures)
                
             
            elif event == 'No':
                sentence = str(mood_questions.pop(0))
        

        elif sentence == 'Are you feeling stressed?':
            if event == 'Yes':
                state = 2
                list(prolog.query("confirm_mood(stressed)"))
                print("Asserted mood(stressed)")
                all_gestures = list(prolog.query("all_reactions(L)"))[0]['L']
                random.shuffle(all_gestures)
                
             
            elif event == 'No':
                sentence = str(mood_questions.pop(0))


        elif sentence == 'Are you feeling fearful?':
            if event == 'Yes':
                state = 2
                list(prolog.query("confirm_mood(fearful)"))
                print("Asserted mood(fearful)")
                all_gestures = list(prolog.query("all_reactions(L)"))[0]['L']
                random.shuffle(all_gestures)
                
             
            elif event == 'No':
                sentence = str(mood_questions.pop(0))


        elif sentence == 'Are you feeling panic stricken?':
            if event == 'Yes':
                state = 2
                list(prolog.query("confirm_mood(panic_stricken)"))
                print("Asserted mood(panic_stricken)")
                all_gestures = list(prolog.query("all_reactions(L)"))[0]['L']
                random.shuffle(all_gestures)
                
             
            elif event == 'No':
                list(prolog.query("confirm_mood(calm)"))
                print("Asserted pain free")
                state = 2
                all_gestures = list(prolog.query("all_reactions(L)"))[0]['L']
                random.shuffle(all_gestures)
        

    elif state == 2:
        # Check each and every symptom, if user has it, assert it in the KB and do the relevant incremenetation.
        # If symptoms list to query is empty, diagnose the user
        try:
            if symptom == 'lump':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any lump?"
                
                
            elif symptom == 'whiteheads':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any whitehead?"
                
                
            elif symptom == 'blackheads':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any blackhead?"
                
                
            elif symptom == 'pus':
                sentence = str(all_gestures.pop(0))
                sentence += " Did you secrete pus?"
                
                
            elif symptom == 'cyst':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any cyst?"
                
                
            elif symptom == 'scar':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any scar?"
                
                
            elif symptom == 'cough':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have cough?"
                
                
            elif symptom == 'runny_nose':
                sentence = str(all_gestures.pop(0))
                sentence += " Are you having runny nose?"
                
                
            elif symptom == 'ache':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any ache?"
                
                
            elif symptom == 'weak':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you feel that your body is weak?"
                
                    
            elif symptom == 'tired':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you feel perpetually tired?"
                
                
            elif symptom == 'fever':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have a fever?"
                
                
            elif symptom == 'rash':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any rash?"
                
                
            elif symptom == 'wheeze':
                sentence = str(all_gestures.pop(0))
                sentence += " Are you wheezing?"
                
                
            elif symptom == 'sneeze ':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you sneeze frequently?"
                
                
            elif symptom == 'red_eye':
                sentence = str(all_gestures.pop(0))
                sentence += " Did you have red eye?"
            
                
            elif symptom == 'loss_of_speech':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you sometimes experience loss of speech?"
                
                
            elif symptom == 'no_appetite':
                sentence = str(all_gestures.pop(0))
                sentence += " Did you experience lack of apetite?"
                
                
            elif symptom == 'leg_swell':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any swelling on your leg?"
               
                
            elif symptom == 'chest_pain':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any chest pain?"
                
                
            elif symptom == 'weight_loss':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any chest pain?"
                
                
            elif symptom == 'pee_frequently':
                sentence = str(all_gestures.pop(0))
                sentence += " Did you have to use the bathroom frequently?"
                
                
            elif symptom == 'thirst':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you always feel thirsty?"
                
                
            elif symptom == 'blur_vision':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any blur vision?"

            elif symptom == 'dry_mouth':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have a dry mouth?"

            elif symptom == 'infection':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you have any infection?"

            elif symptom == 'pale_skin':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you sometimes have pale_skin?"

            elif symptom == 'breathless':
                sentence = str(all_gestures.pop(0))
                sentence += " Did you experience breathlessness?"

            elif symptom == 'bleed':
                sentence = str(all_gestures.pop(0))
                sentence += " Do you often bleed?"

            window['text'].update(sentence)
            window.Refresh()
            # engine.say(sentence)
            # engine.runAndWait()
            event, values = window.read()
            if event == 'Yes':
                list(prolog.query("merge(" + symptom + ")"))
                print("Asserted has " + symptom)
            symptom = str(symptoms.pop(0))

        except IndexError:
            state = 3
       

    elif state == 3:
        # Diagnose the user by querying the KB.
        # The KB should return the disease with the highest count value
        diagnosis = list(prolog.query('diagnose(L)'))[0]['L']
        # fever = list(prolog.query('count_fever(L)'))[0]['L']
        # injury = list(prolog.query('count_fever(L)'))[0]['L']
        if diagnosis == 'acne':
            sentence = 'I diagnose that you have an acne.'
        elif diagnosis == 'flu':
            sentence = 'I diagnose that you have a flu.'
        elif diagnosis == 'allergy':
            sentence = 'I diagnose that you have an allergy.'
        elif diagnosis == 'covid_19':
            sentence = 'I am sorry but you have COVID-19.'
        elif diagnosis == 'heart_disease':
            sentence = 'I apologize but you have heart disease.'
        elif diagnosis == 'high_blood_sugar':
            sentence = 'I diagnose that you have high blood sugar.'
        elif diagnosis == 'cancer':
            sentence = 'I regret to inform you that you have cancer.'
        print(sentence)
        window['text'].update(sentence)
        window.Refresh()
        tts = _TTS()
        tts.start(sentence)
        del(tts)

        event, values = window.read()
        if event:
            break
            


    if not (state == 2 or state == 3):
        window['text'].update(sentence)
        window.Refresh()




    

window.close()



