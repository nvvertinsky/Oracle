select cast(13 as text);
select 13::real;

select cast(array[1,2,3+4] as text);
select array[[1,2,3+4],[1,2,3]];

create table arr(f1 int[], f2 int[]);
insert into arr values (array[[1,2],[3,4]], array[[5,6],[7,8]]);
select array[f1, f2, '{{9,10},{11,12}}'::int[]] from arr;











