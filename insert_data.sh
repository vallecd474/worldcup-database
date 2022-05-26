#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do 
  if [[ $YEAR != "year" ]]
  then
      TEAM_ID1=$($PSQL "select team_id from teams where name='$WINNER'")
      if [[ -z $TEAM_ID1 ]]
      then
          INSERT_TEAM_NAME1=$($PSQL "insert into teams(name) values('$WINNER')")
          if [[ $INSERT_TEAM_NAME1 == "INSERT 0 1" ]]
          then
              echo Inserted into team, $WINNER
          fi
          TEAM_ID1=$($PSQL "select team_id from teams where name='$WINNER'")
          echo $TEAM_ID1
      fi
      TEAM_ID2=$($PSQL "select team_id from teams where name='$OPPONENT'")
      if [[ -z $TEAM_ID2 ]]
      then
          INSERT_TEAM_NAME2=$($PSQL "insert into teams(name) values('$OPPONENT')")
          if [[ $INSERT_TEAM_NAME2 == "INSERT 0 1" ]]
          then
              echo Inserted into team, $OPPONENT
          fi
          TEAM_ID2=$($PSQL "select team_id from teams where name='$OPPONENT'")
      fi
      INSERT_GAME=$($PSQL "insert into games(year,round,winner_goals,opponent_goals,winner_id,opponent_id) values($YEAR,'$ROUND',$WINNER_GOALS,$OPPONENT_GOALS,$TEAM_ID1,$TEAM_ID2)")
      if [[ $INSERT_GAME == "INSERT 0 1" ]]
          then
              echo Inserted into GAME, $YEAR $ROUND
      fi
  fi    
done  