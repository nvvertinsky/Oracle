-- Глобальные индексы могут использоваться для обеспечения уникальности первичному ключу. 

create index partitioned_index on partition(id) global
partition by range(id)
(
partition part_1 values less than (1000),
partition part_1 values less than (maxvalue)
);

alter table partitioned add constraint partitioned_pk primary key(id);

-- Теперь Oracle использует созданный нами глобальный индекс для поддержания первичного ключа.