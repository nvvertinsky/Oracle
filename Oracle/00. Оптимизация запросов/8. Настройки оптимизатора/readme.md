### Настройки оптимизатора
````
select t.value from v$parameter t where t.name = 'optimizer_mode'; -- Какой режим работы оптимизатора включен
alter system set optimizer_mode = all_rows;                        -- переключить режим работы оптимизатора в rule на уровне БД.
alter session set optimizer_mode = all_rows;                       -- переключить режим работы оптимизатора в rule на уровне сессии.
````