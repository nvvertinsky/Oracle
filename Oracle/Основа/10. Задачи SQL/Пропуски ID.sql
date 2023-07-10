/*
Есть таблица t c колонкой id.
В id хранятся целые положительные числа. Например: 1,2,3,4,5,6,10,11,12
Необходимо найти все ID которые пропущены

*/


select v.id + 1 start,
       v.next_id - 1 next_id end
  from (select id, 
               lead(id) over (order by id) next_id 
		  from t) v 
		 where v.id + 1 != v.next_id;