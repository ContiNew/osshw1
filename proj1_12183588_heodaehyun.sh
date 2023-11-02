#!/bin/bash
fin="N"
until [ $fin="Y" ]
do
    echo "---------------------------------------------"
    echo "User Name : $(whoami)"
    echo "Student Number : 12183588"
    echo "Made by Heo DaeHyun."
    echo "[Menu]"
    echo "1. Get the data of the movie identified by a specific 'movie id' from 'u.item'"
    echo "2. Get the data of action genre movies from 'u.item'"
    echo "3. Get the average 'rating’ of the movie identified by specific 'movie id' from 'u.data’"
    echo "4. Delete the ‘IMDb URL’ from ‘u.item"
    echo "5. Get the data about users from 'u.user"
    echo "6. Modify the format of 'release date' in 'u.item"
    echo "7. Get the data of movies rated by a specific 'user id' from 'u.data'"
    echo "8. Get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'"
    echo "9. Exit"
    echo "---------------------------------------------"
    read -p "Enter Your Choice [1-9]: " choice
    case $choice in
    9) 
        echo "Bye!"
        fin="Y"
        ;;
    *)  echo "On Develop"
        fin="Y"
        ;;
    esac
done