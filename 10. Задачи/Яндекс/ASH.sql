/*
Что за аббревиатура ASH?
Назовите одно из представлений.
Можно ли найти запрос в ASH если он длился 5 секунд?
*/

Active Session History

select * from v$active_session_history

Да, так как снимок делается каждую секунду. 