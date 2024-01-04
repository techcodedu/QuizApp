from flask import render_template, request, redirect, url_for, session
from quizapp import app, mysql
from datetime import datetime
import random

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/start_game', methods=['POST'])
def start_game():
    player_name = request.form['player_name']
    session.clear()
    session['player_name'] = player_name
    session['score'] = 0
    session['question_ids_asked'] = []
    session['question_number'] = 1
    session['start_time'] = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')  # Store start time as a UTC string
    return redirect(url_for('game'))


@app.route('/game')
def game():
    if 'question_ids_asked' not in session or len(session['question_ids_asked']) >= 10:
        return redirect(url_for('results'))

    question = get_next_question()
    if question is None:
        # Handle the case when no more questions are available
        return redirect(url_for('results'))

    session['correct_choice'] = question['correct_choice_id']
    return render_template('game.html', question=question)


@app.route('/answer', methods=['POST'])
def answer():
    if 'correct_choice' not in session or 'choice' not in request.form:
        # If the correct_choice is not in session or no choice was made, redirect to game
        return redirect(url_for('game'))

    # Get the choice from the form or default to 0 if not found
    selected_choice = int(request.form.get('choice', 0))
    
    correct_choice = session['correct_choice']
    
    if selected_choice == correct_choice:
        session['score'] += 1
    
    # Increment question number and append the id of the question that was just answered
    session['question_number'] = session.get('question_number', 1) + 1
    session['question_ids_asked'].append(correct_choice)
    
    if session['question_number'] > 10:
        return redirect(url_for('results'))
    else:
        return redirect(url_for('game'))


@app.route('/results')
def results():
    score = session.get('score', 0)
    player_name = session.get('player_name', 'Player')
    start_time_str = session.get('start_time')

    # Convert start_time from string back to datetime
    if start_time_str:
        start_time = datetime.strptime(start_time_str, '%Y-%m-%d %H:%M:%S')
    else:
        start_time = datetime.utcnow()  # Fallback if start_time is not in session

    # Use utcnow() for end_time to be consistent with start_time
    end_time = datetime.utcnow()
    duration_of_play = (end_time - start_time).total_seconds()

    cursor = mysql.connection.cursor()

    # Insert player data into the player table
    insert_player_query = '''
    INSERT INTO player (name, start_time, end_time, score, duration_of_play) 
    VALUES (%s, %s, %s, %s, %s)
    '''
    cursor.execute(insert_player_query, (player_name, start_time, end_time, score, duration_of_play))

    # Retrieve the last inserted player_id
    player_id = cursor.lastrowid

    # Insert score data into the highscore table
    insert_score_query = '''
    INSERT INTO highscore (player_id, score, time) 
    VALUES (%s, %s, %s)
    '''
    cursor.execute(insert_score_query, (player_id, score, duration_of_play))


    mysql.connection.commit()
    cursor.close()

    # Clear the session
    session.clear()

    return render_template('results.html', score=score, player_name=player_name)



def get_next_question():
    cursor = mysql.connection.cursor()
    # Make sure to handle the case where no questions have been asked yet
    if not session.get('question_ids_asked'):
        cursor.execute("SELECT * FROM question ORDER BY RAND() LIMIT 1")
    else:
        placeholders = ', '.join(['%s'] * len(session['question_ids_asked']))
        cursor.execute(f"SELECT * FROM question WHERE id NOT IN ({placeholders}) ORDER BY RAND() LIMIT 1", 
                    session['question_ids_asked'])
    
    question_row = cursor.fetchone()
    if question_row:
        # Fetch the fruit names for the choice IDs
        cursor.execute("SELECT id, name FROM fruits WHERE id IN (%s, %s, %s, %s)", 
                       (question_row['choice_1_id'], 
                        question_row['choice_2_id'], 
                        question_row['choice_3_id'], 
                        question_row['choice_4_id']))
        choices = cursor.fetchall()

        # Fetch the correct fruit's image URL
        cursor.execute("SELECT image_url FROM fruits WHERE id = %s", (question_row['correct_choice_id'],))
        correct_fruit_image = cursor.fetchone()

        question = {
            'text': 'Which one is this fruit?',
            'image_url': correct_fruit_image['image_url'],
            'choices': choices,
            'correct_choice_id': question_row['correct_choice_id']
        }

        return question

    cursor.close()
    return None


@app.route('/highscores')
def highscores():
    cursor = mysql.connection.cursor()

    # Execute the query without DATE_FORMAT
    cursor.execute('''
        SELECT p.name AS Username, h.score AS Score, h.time AS Time, p.start_time
        FROM highscore h
        JOIN player p ON h.player_id = p.id
        ORDER BY h.score DESC, h.time ASC, p.start_time ASC
    ''')

    highscores = cursor.fetchall()
    cursor.close()

    # Format the date in Python
    for highscore in highscores:
        highscore['DatePlayed'] = highscore['start_time'].strftime('%m/%d/%Y')

    return render_template('highscores.html', highscores=highscores)


