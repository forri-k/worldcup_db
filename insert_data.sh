#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#delete data in teams and games
echo $($PSQL "TRUNCATE teams, games")
#read = year,round,winner,opponent,winner_goals,opponent_goals
cat games_test.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != winner ]]
  then
    #get team_id from winner
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")
    #if not found
    if [[ -z $WINNER_ID ]]
    then
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_NAME == 'INSERT 0 1' ]]
      then 
        echo 'Inserted into names, '$WINNER''
      fi
      WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER' ")
    fi
  fi
  if [[ $OPPONENT != opponent ]]
  then
    #get team_id from opponent
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' ")
    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      if [[ $INSERT_TEAM_NAME == 'INSERT 0 1' ]]
      then 
        echo 'Inserted into names, '$OPPONENT''
      fi
      #GET OPPONENT ID
      OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT' ")
    fi
  fi
  INSERT_INTO_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
  if [[ $INSERT_INTO_GAMES == 'INSERT 0 1' ]]
  then 
    echo 'inserted line into games'
  else
    echo 'problemo'
  fi
done