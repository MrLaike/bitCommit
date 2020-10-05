#!/bin/bash

HOOK_KEY="knl8n13t9qon1ygs"
USER_ID=68
TASK_ID=1704
PROTOCOL=https
SITE=asap64.bitrix24.ru
FORMATE='%Y-%m-%d %T'


filter='FILTER[]=&'
order='ORDER[]=&'
params='PARAMS[]=&'
select='SELECT[]=&'

setSection() {
	echo 1
}

getUrlWithToken() {
	echo $PROTOCOL://$SITE/rest/$USER_ID/$HOOK_KEY/
}


getProfile() {
	action=profile
	curl `getUrlWithToken`$action | jq -r '.result'
}

getAllTask() {
	action=task.item.list
	filter='FILTER[ACCOMPLICE]='$USER_ID'&'
	order='ORDER[TITLE]=asc&'
	select='SELECT[ID]=ID&'
	#echo `getUrlWithToken`$action?$order$filter$params$select
	curl `getUrlWithToken`$action?$order$filter$params$select | jq -r '.result'
}

setTask() {
	echo 1	
}
timeToSeconds() {
	echo $1
}

commit() {
	action=task.elapseditem.add
	#taskId="$1&"
	#time="ARFIELDS[SECONDS]=$2&"
	#comment='ARFIELDS[COMMENT_TEXT]='"$3&"
	datetime="ARFIELDS[CREATED_DATE]='$(date +"$FORMATE")'"
	echo `getUrlWithToken`$action?$taskId$time$comment$datetime

	curl -g "`getUrlWithToken`$action?TASKID=$taskId&ARFIELDS[SECONDS]=$time&ARFIELDS[COMMENT_TEXT]=$comment&$datetime" | jq -r 
}


while [[ $# -gt 0 ]]
do
key="$1"

case $key in
	-i|--id)
	taskId="$2"
	shift
	shift
	;;
    -t|--time)
    time="$2"
    shift 
    shift 
    ;;
    -m|--message)
    comment="$2"
	echo $2
    shift 
    shift 
    ;;
	*)    
    function+=("$1") 
    shift  
    ;;
esac
done

echo comment

$function
#MINUTES: 123,COMMENT_TEXT:'Api test',CREATED_DATE:'2016-03-20 17:26:37'} 

