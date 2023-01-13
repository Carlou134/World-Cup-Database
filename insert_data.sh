#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
#------------TEAMS INSERTED----------
#Winners

  TEAM_1=$($PSQL "SELECT name FROM teams WHERE name='$WINNER';")

  if [[ $WINNER != 'winner' ]]
  then
    if [[ $TEAM_1 != $WINNER ]]
    then
      INSERTED=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
    fi
  fi

#Opponents

  TEAM_1=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT';")

  if [[ $OPPONENT != 'opponent' ]]
  then
    if [[ $TEAM_1 != $OPPONENT ]]
    then
      INSERTED=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    fi
  fi

  if [[ $INSERTED == 'INSERT 0 1' ]]
  then
    echo new team inserted
  else
    echo '...'
  fi

#------------MATCHS INSERTED----------
if [[ $WINNER != 'winner' ]]
then
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    GAME_INSERTED=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
fi

if [[ $GAME_INSERTED == 'INSERT 0 1' ]]
then
  echo new game inserted
else
  echo '...'
fi
done