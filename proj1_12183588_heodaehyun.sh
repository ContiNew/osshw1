#! /bin/bash

#function definitions
getMonth(){
    val=
    case $1 in
        Jan)
            val="01"
            ;;
        Feb)
            val="02"
            ;;
        Mar) 
            val="03"
            ;;
        Apr)
            val="04"    
            ;;
        May)
            val="05"
            ;;
        Jun)
            val="06"
            ;;
        Jul)
            val="07"
            ;;
        Aug)
            val="08"
            ;;
        Sep)
            val="09"
            ;;
        Oct)
            val="10"
            ;;
        Nov)
            val="11"
            ;;
        Dec)
            val="12"
            ;;
        *)
            val="err"
            ;;
    esac 
    echo $val
}
#main

fin="N"
echo "---------------------------------------------"
echo "User Name : $(whoami)"
echo "Student Number : 12183588, Heo DaeHyun"
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
        cat $1 | tr ' ' '_' | tr '|' ' ' | awk -v movieid="$movieid" '$1==movieid{print $0}'| tr ' ' '|' | tr '_' ' '
        ;;
    2) 
        read -p "Do you want to get the data of \"action\" gerne movies from 'u.item'? (Y/N): " select
        case $select in
        Y|y|yes|Yes|YES)
            cat $1 | tr ' ' '_' |tr '|' ' '| awk '$7==1 {print $1, $2}' | tr '_' ' ' 
            #액션 영화는 tr로 전치를 했을 떄, 7번째 열이다.
            ;;
        N|n|no|No|NO)
            echo "back to the menu"
            ;;
        *) 
            echo "invalid selection"
            ;;
        esac 
        ;;
    3)
        read -p "Please Enter 'movie id' (1~1682): " movieid
        ratings=$(awk -v movid="${movieid}" '$2==movid {print $3}' <$2) #awk를 이용해 movieid 에 해당되는 모든 평가를 들고옴
        count=$(echo "$ratings" | wc -l) # wc -ㅣ을 이용해서 카운트 
        sum=0
        ratings=$(echo "$ratings" | tr '\n' ' ') #for 문을 쓸 수 있도록 개행을 공백으로 대체
        for i in ${ratings}
        do 
            sum=$(( sum+=i ))
        done 
        res=$(echo "${sum} ${count}" |awk '{printf("%.5f", $1 / $2)}') # bash 쉘 내장 기능으로는 소수점 연산이 안됨
        echo "average rating of ${movieid}: ${res}"
        ;;
    4)
        read -p "Do you want to delete the ‘IMDb URL’ from ‘u.item’? (Y/N):" select
        case $select in
        Y|y|yes|Yes|YES)
            head -10 $1| tr ' ' '_' | tr '|' ' ' | awk '{$4=" "}1' | tr ' ' '|'| tr '_' ' ' | cat 
            # head를 통해서 10줄만을 불러오고 이를 파이프를 이용해 tr로 넘겨서 awk를 활용할 수 있도록 바꾸고, 
            # 전치가 완료되면 이를 다시 역으로 tr 해서 원래 포맷으로 되돌린 뒤 cat 하여 출력한다. 
            ;;
        N|n|no|No|NO)
            echo "back to the menu"
            ;;
        *) 
            echo "invalid selection"
            ;;
        esac 
        ;;
    5)
        read -p "Do you want to get the data about users from ‘u.user’? (Y/N): " select
        case $select in
        Y|y|yes|Yes|YES)
            users=$(head -10 $3|tr '\n' ' ') # for 문을 사용할 수 있도록 개행을 공백으로 대체
            for user in ${users}
            do 
                info=$(echo $user| tr '|' ' ') # awk를 쓸 수 있도록 형태 변경
                userid=$(echo $info| awk '{print $1}')
                age=$(echo $info| awk '{print $2}')
                gender=$(echo $info| awk '{print $3}')
                if [ $gender = 'M' ]; then # gender 정보를 이용해서 조건문으로 female male을 표시할 수 있도록 변수에 저장
                    gender='male'
                else
                    gender='female'
                fi
                occupation=$(echo $info| awk '{print $4}')
                echo "user "$userid" is "$age" years old "$gender" "$occupation""
            done
            ;;
        N|n|no|No|NO)
            echo "back to the menu"
            ;;
        *) 
            echo "invalid selection"
            ;;
        esac 
        ;;
    6)
        read -p "Do you want to Modify the format of ‘release data’ in ‘u.item’(Y/N)?" select
        case $select in
        Y|y|yes|Yes|YES)
            sources=$(tail -10 $1|tr ' ' '_'| tr '\n' ' ')
            for line in ${sources}
            do
                date=$(echo $line | tr '|' ' ' | awk '{print $3}'| tr '-' ' ')
                month=$(echo $date | awk '{print $2}')
                month=$(getMonth $month)
                day=$(echo $date | awk '{print $1}')
                year=$(echo $date | awk '{print $3}')
                date="$year$month$day"
                echo $line |tr '|' ' ' | awk -v date="$date" '{$3=date}1' | tr ' ' '|'|tr '_' ' '
            done
            ;;
        N|n|no|No|NO)
            echo "back to the menu"
            ;;
        *) 
            echo "invalid selection"
            ;;
        esac 
        ;;
    7)
        read -p "Please Enter ‘user id’(1~943): " userid
        data_with_uid=$(awk -v uid="$userid" '$1==uid{print $2}' < $2 | sort -g | tr '\n' ' ') 
        #uid와 일치하는 movieid들을 찾는다. 그후, sort 함수를 통해서 정렬하고, 개행을 공백으로 변경한다.
        echo $data_with_uid | tr ' ' '|' # 공백을 |로 바꾸어서 출력한다.
        movieid_list=$(echo $data_with_uid | tr ' ' '\n' | head -10 | tr '\n' ' ') # head를 이용해 상위 10개의 movieid를 리스트로 만든다
        echo
        for movieid in $movieid_list
        do
          cat $1 | tr ' ' '_' | tr '|' ' ' | awk -v movieid="$movieid" '$1==movieid{print $1,$2}' | tr ' ' '|' | tr '_' ' '
        done
        ;;
    8)
        read -p "Do you want to get the average 'rating' of movies rated by users with 'age' between 20 and 29 and 'occupation' as 'programmer'?(Y/N)" select
        case $select in
        Y|y|yes|Yes|YES)
            users=$(cat $3| tr '|' ' ' | awk '$2<=29 && $2>=20 && $4=="programmer"{print $1}'| tr '\n' ' ')
            num_of_movies=$(wc -l $1 | awk '{print $1}')
            ratings=$(cat $2|awk '{print $1, $2, $3}')
            # 조건에 맞는 user의 uid를 리스트로 가져온다. 또한 wc를 이용해 전체 영화의 갯수를 가져온다.
            for movieid in $(seq 1 "${num_of_movies}")
            do
                sum=0; count=0
                for user in $users
                do
                    rating=$(printf '%s' "${ratings}" |awk -v mid="$movieid" -v uid="$user" '$1==uid && $2==mid{print $3}') # 해당하는 레이팅을 구함
                    if [ "${rating}" ]; then
                        sum=$((sum=sum+rating)) #레이팅을 sum에 저장
                        count=$((++count)) # 레이팅 갯수를 샌다 
                    fi
                done
                if [ $count != 0 ]; then
                    avg=$(echo "${sum} ${count}" |awk '{printf("%.5f", $1 / $2)}') # movieid에 대해 평균레이팅을 구함
                    echo "${movieid}" "${avg}"  # 구한 값을 출력
                fi
            done
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
    *)  echo "invalid selection, Good Bye"
        fin="Y" 
        ;;
    esac
done

