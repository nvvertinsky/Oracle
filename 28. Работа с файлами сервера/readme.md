# Работа с файлами сервера


### 1. Дать доступ к директории
````
GRANT READ, WRITE ON DIRECTORY TEST_DIR TO nvvertinskiy;
````

### 2. У пользователя ORACLE в операционной среде так же должны быть доступа создавать и редактировать файлы.

### 2. Записать файл на диск, чтобы протестировать.
````
declare
  file1 utl_file.file_type;
begin
  file1 := utl_file.fopen('ЛЮБАЯ ТЕСТОВАЯ ДИРЕКТОРИЯ', 'sample.txt', 'w');
  utl_file.put_line(file1, 'Welcome');
  utl_file.fclose(file1);
end;
````