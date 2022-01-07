create table lol (lol_id number(12), lol_name varchar2(240), surname varchar2(240));

insert into lol values (1, 'Niko', 'Surname');
insert into lol values (2, 'Niko', 'Surname');
insert into lol values (3, 'Jane', 'Surname');
insert into lol values (4, 'Jane', 'Surname');
insert into lol values (5, 'Ivan', 'Surname');

select * from lol

select max(lol_id), lol_name
from lol
group by lol_name
having count(lol_id) > 1