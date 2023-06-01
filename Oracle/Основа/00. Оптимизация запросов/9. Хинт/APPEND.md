# Хинт APPEND 


### Описание
  - Управляет функционалом прямой вставки в таблицу, посредством уменьшения генерации UNDO и REDO.
  

### Когда логи UNDO и REDO не будут генерится: 

Table Mode    Insert Mode     ArchiveLog mode      result
-----------   -------------   -----------------    ----------
LOGGING       APPEND          ARCHIVE LOG          redo generated
NOLOGGING     APPEND          ARCHIVE LOG          no redo
LOGGING       no append       ARCHIVE LOG          redo generated
NOLOGGING     no append       ARCHIVE LOG          redo generated
LOGGING       APPEND          noarchive log mode   no redo
NOLOGGING     APPEND          noarchive log mode   no redo
LOGGING       no append       noarchive log mode   redo generated
NOLOGGING     no append       noarchive log mode   redo generated


### Когда использовать: 
  - При вставке больших объемов данных в таблицу
  

### Как работает: 
  - Данные будут писаться после выше точки HWM. То есть данные будут вставляться начиная с блока, следующего за последним использованным блоком.
    - Например если вы удалите delete все данные в таблице, то вставка не будет использовать все освободившееся место. Придется скидывать HWM.


### Что с индексами делать: 
Индексы всегда генерят REDO. Чтобы обойти это нужно: 
  1. Поэтому индексы стоит отключать.
  2. Установить параметр сессии, так чтобы пропускать индексы unusable
  3. Прозвести прямую вставку
  4. Включить обратно индексы и перестроить их 
  
````
alter index big_table_idx unusable;
alter session set skip_unusable_indexes = true;
insert /*APPEND*/ into big_table select * from all_objects; 
alter index big_table_idx rebuild nologging;
````

  