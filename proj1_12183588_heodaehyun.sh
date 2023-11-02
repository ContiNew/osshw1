#! /bin/bash
fin="N"
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
until [ $fin = "Y" ]
do
    read -p "Enter Your Choice [1-9]: " choice
    case $choice in
    1)
        read -p "Please Enter 'movie id' (1~1682): " movieid
        movieid=$movieid'|' # 문자열을 concat 해서 패턴 매칭용 스트링으로 만든다.
        grep "^${movieid}" < $1  # u.item에서 내용을 받아 grep을 이용해 movieid로 시작하는 문자열을 모두 가져온다. 
        ;;
    2) 
        read -p "Do you want to get the data of \"action\" gerne movies from 'u.item'? (Y/N): " select
        case $select in
        Y|y|yes|Yes|YES)
            cat $1 | tr '|' ' '| awk '$7==1 {print $1, $2, $3}'
            ;;
        N|n|no|No|NO)
            echo "back to the menu"
            ;;
        *) 
            echo "invalid selection"
            ;;
        esac 
        ;;
    9) 
        echo "Bye!"
        fin="Y"
        ;;
    *)  echo "On Develop"
        fin="Y" 
        ;;
    esac
done